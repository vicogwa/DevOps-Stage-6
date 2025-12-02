terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }

  # Remote backend for state management
  backend "s3" {
    bucket         = "devops-stage6-terraform-state-adewumi"  
    key            = "todo-app/terraform.tfstate"
    region         = "us-east-1"  
    encrypt        = true
    dynamodb_table = "terraform-state-lock"  
  }
}
