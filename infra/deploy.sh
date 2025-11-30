#!/bin/bash

set -e

echo "Starting infrastructure deployment..."

# Check if terraform.tfvars exists
if [ ! -f "terraform/terraform.tfvars" ]; then
    echo "Error: terraform/terraform.tfvars not found!"
    echo "Please copy terraform.tfvars.example to terraform.tfvars and configure it."
    exit 1
fi

# Navigate to terraform directory
cd terraform

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Plan infrastructure changes
echo "Planning infrastructure changes..."
terraform plan -out=tfplan

# Apply infrastructure changes
echo "Applying infrastructure changes..."
terraform apply -auto-approve tfplan

echo "Infrastructure deployment completed successfully!"
echo "Server IP: $(terraform output -raw server_public_ip)"