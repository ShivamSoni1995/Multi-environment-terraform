# Terraform AWS Production Infrastructure

This repository contains reusable Terraform modules and environment configs to deploy a production-ready web application infrastructure on AWS.

## � Components

- VPC with public/private subnets across 2 AZs
- NAT Gateway and custom route tables
- EC2 Auto Scaling Group and Launch Template
- ALB with target group and health checks
- RDS (MySQL/PostgreSQL) in private subnet
- S3 bucket for static assets
- CloudWatch alarms and logs
- IAM roles and instance profiles

## � Environments

- `dev/` — development environment
- `prod/` — production-grade environment with remote state

## � Deployment

```bash
cd environments/prod
terraform init
terraform plan
terraform apply

