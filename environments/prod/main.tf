provider "aws" {
  region = "ap-south-1"
}
module "vpc" {
  source         = "../../modules/vpc"
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  env            = var.env
}