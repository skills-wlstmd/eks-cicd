data "aws_ssm_parameter" "latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-default-x86_64"
}

## Keypair
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "keypair" {
  key_name = "dev"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "keypair" {
  content = tls_private_key.rsa.private_key_pem
  filename = "./dev.pem"
}

resource "aws_instance" "bastion" {
  ami = data.aws_ssm_parameter.latest_ami.value
  subnet_id = aws_subnet.public_a.id
  instance_type = "t3.small"
  key_name = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y jq curl wget zip
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    ln -s /usr/local/bin/aws /usr/bin/
    ln -s /usr/local/bin/aws_completer /usr/bin/
    sed -i "s|#PasswordAuthentication no|PasswordAuthentication yes|g" /etc/ssh/sshd_config
    echo "Port 2222" >> /etc/ssh/sshd_config
    systemctl restart sshd
    echo 'Skill53!@#' | passwd --stdin ec2-user
    echo 'Skill53!@#' | passwd --stdin root
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.2/2024-07-12/bin/linux/amd64/kubectl
    chmod +x kubectl
    mv kubectl /usr/local/bin
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    mv get_helm.sh /usr/local/bin
    yum install -y docker
    systemctl enable --now docker
    usermod -aG docker ec2-user
    usermod -aG docker root
    chmod 666 /var/run/docker.sock
    sudo yum install -y git
    mkdir ~/dev-commit
    mkdir ~/eks
    mkdir ~/yaml
    sudo chown ec2-user:ec2-user ~/dev-commit
    sudo chown ec2-user:ec2-user ~/eks
    sudo chown ec2-user:ec2-user ~/yaml
    su - ec2-user -c 'aws s3 cp s3://${aws_s3_bucket.app.id}/ ~/dev-commit --recursive'
    su - ec2-user -c 'cp -r ~/dev-commit/k8s-yaml/eks/ ~/eks/'
    su - ec2-user -c 'cp -r ~/dev-commit/k8s-yaml/yaml/ ~/yaml/'
    su - ec2-user -c 'git config --global credential.helper "!aws codecommit credential-helper $@"'
    su - ec2-user -c 'git config --global credential.UseHttpPath true'
    su - ec2-user -c 'cd ~/dev-commit && git init && git add .'
    su - ec2-user -c 'cd ~/dev-commit && git commit -m "day1"'
    su - ec2-user -c 'cd ~/dev-commit && git branch dev'
    su - ec2-user -c 'cd ~/dev-commit && git checkout dev'
    su - ec2-user -c 'cd ~/dev-commit && git remote add origin ${aws_codecommit_repository.commit.clone_url_http}'
    su - ec2-user -c 'cd ~/dev-commit && git push origin dev'
    aws s3 rm s3://${aws_s3_bucket.app.id} --recursive
    aws s3 rb s3://${aws_s3_bucket.app.id} --force
  EOF
  tags = {
    Name = "dev-bastion-ec2"
  }
}

resource "aws_security_group" "bastion" {
  name = "dev-EC2-SG"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "2222"
    to_port = "2222"
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "22"
    to_port = "22"
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "80"
    to_port = "80"
  }
 
  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "443"
    to_port = "443"
  }

    tags = {
    Name = "dev-EC2-SG"
  }
}

## IAM
resource "aws_iam_role" "bastion" {
  name = "dev-role-bastion"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_instance_profile" "bastion" {
  name = "dev-profile-bastion"
  role = aws_iam_role.bastion.name
}