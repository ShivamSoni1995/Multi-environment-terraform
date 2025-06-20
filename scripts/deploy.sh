#!/bin/bash
ENV=$1
cd environments/$ENV || exit
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars -auto-approve
