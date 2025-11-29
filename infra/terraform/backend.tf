terraform {
  backend "s3" {
    bucket         = "my-terraform-state-1764405165"
    key            = "microservices/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}