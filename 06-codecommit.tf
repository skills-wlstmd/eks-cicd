resource "aws_codecommit_repository" "commit" {
    repository_name = "dev-commit"
    default_branch = "dev"
    
    lifecycle {
        ignore_changes = [default_branch]
    }
    
    tags = {
      Name = "dev-commit"
    } 
}