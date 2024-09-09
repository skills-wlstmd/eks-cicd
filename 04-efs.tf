resource "aws_security_group" "efs" {
  name = "dev-EFS-SG"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "2049"
    to_port = "2049"
  }

  egress {
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "0"
    to_port = "0"
  }

    tags = {
    Name = "dev-EC2-SG"
  }
}

resource "aws_efs_file_system" "efs" {
  creation_token = "dev-efs"
  performance_mode = "generalPurpose"

  tags = {
    Name = "dev-efs"
  }
}

resource "aws_efs_mount_target" "efs_target_a" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private_a.id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "efs_target_b" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private_b.id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "efs_target_c" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private_c.id
  security_groups = [aws_security_group.efs.id]
}