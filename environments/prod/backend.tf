terraform {
  backend "s3" {
    bucket         = "terraform-state-yourname"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}