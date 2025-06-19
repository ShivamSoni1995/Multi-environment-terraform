# Terraform AWS Production Infrastructure

This repository contains reusable Terraform modules and environment configs to deploy a production-ready web application infrastructure on AWS.

terraform-aws-prod-infra/
├── modules/
│   ├── vpc/
│   ├── ec2/
│   ├── alb/
│   ├── rds/
│   └── s3/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── backend.tf
├── scripts/
│   └── deploy.sh
└── README.md


## 🔧 Components

- VPC with public/private subnets across 2 AZs
- NAT Gateway and custom route tables
- EC2 Auto Scaling Group and Launch Template
- ALB with target group and health checks
- RDS (MySQL/PostgreSQL) in private subnet
- S3 bucket for static assets
- CloudWatch alarms and logs
- IAM roles and instance profiles

## 🚀 Environments

- `dev/` — development environment
- `prod/` — production-grade environment with remote state

## 📦 Deployment

```bash
cd environments/prod
terraform init
terraform plan
terraform apply

```
Implementing **strict access control policies** in Terraform-managed environments is crucial to secure infrastructure and avoid unintentional or malicious changes — especially in production. Here's a practical guide to enforce **environment-level access control**, tailored for DevOps teams using **AWS, Terraform, and Git-based workflows**.

---

## 🔐 How to Implement Strict Access Control for Terraform Environments

---

### ✅ 1. **Use Separate AWS IAM Roles for Each Environment**

Create **IAM roles** with scoped permissions based on environment (`dev`, `staging`, `prod`). For example:

* **TerraformDevRole**: Full access to dev resources.
* **TerraformProdRole**: Limited to production resources, accessible only by senior/stable team members.

**Example IAM policy for `TerraformProdRole`:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ProdControl",
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "rds:*",
        "s3:*"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:instance/*",
        "arn:aws:rds:*:*:db/*",
        "arn:aws:s3:::prod-bucket/*"
      ]
    }
  ]
}
```

### ✅ 2. **Use Terraform Workspaces or Separate State Files**

Use **Terraform Workspaces** or better yet, **completely separate directories and state backends** for `dev` and `prod`:

```hcl
# environments/dev/backend.tf
key = "dev/terraform.tfstate"

# environments/prod/backend.tf
key = "prod/terraform.tfstate"
```

Then, **restrict access to those backends** using S3 bucket policies or IAM conditions.

---

### ✅ 3. **Enable State Locking and Audit Trails**

Use **DynamoDB state locking** and enable **CloudTrail** to track all changes to:

* S3 state file access
* Terraform plan/apply via assumed roles
* Manual changes to infrastructure

**Example DynamoDB table for locking:**

```bash
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

---

### ✅ 4. **Enforce Git-Based Workflows and Role Assumption**

Only allow Terraform to run via CI/CD pipelines that **assume environment-specific roles**.

In your CI pipeline (GitHub Actions / Jenkins):

```yaml
- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v2
  with:
    role-to-assume: arn:aws:iam::123456789012:role/TerraformProdRole
    aws-region: ap-south-1
```

Then limit **who can trigger CI on the `main` or `prod` branch** using GitHub CODEOWNERS or branch protection rules.

---



### ✅ 5. **Encrypt State and Use Versioning**

In your S3 backend:

* Enable **encryption** (KMS or SSE-S3)
* Turn on **versioning**
* Restrict S3 access via bucket policy (only Terraform roles can access specific state keys)

---



## 🔒 Summary Table

| Layer           | Control Mechanism                         |
| --------------- | ----------------------------------------- |
| IAM             | Role-based permissions (per environment)  |
| State Backend   | Separate backends + restricted access     |
| CI/CD           | Role assumption + scoped execution rights |
| GitHub Branches | Protected branches + CODEOWNERS           |
| Audit & Locking | CloudTrail + DynamoDB state lock          |
| Encryption      | S3 encryption + versioning                |




