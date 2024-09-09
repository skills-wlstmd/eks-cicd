resource "aws_ecr_repository" "blue" {
  name = "dev-blue-ecr"

    tags = {
        Name = "dev-blue-ecr"
    } 
}

resource "aws_ecr_lifecycle_policy" "blue_policy" {
  repository = aws_ecr_repository.blue.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "delete docker image on ecr",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 4
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

resource "aws_ecr_repository" "green" {
  name = "dev-green-ecr"

    tags = {
        Name = "dev-green-ecr"
    } 
}

resource "aws_ecr_lifecycle_policy" "green_policy" {
  repository = aws_ecr_repository.green.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "delete docker image on ecr",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 4
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}