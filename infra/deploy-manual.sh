#!/bin/bash

set -e

echo "Starting manual infrastructure deployment..."

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

# Apply infrastructure changes (without Ansible)
echo "Applying infrastructure changes..."
terraform apply -auto-approve tfplan

# Get server IP
SERVER_IP=$(terraform output -raw server_public_ip)
echo "Server IP: $SERVER_IP"

# Wait for SSH to be available
echo "Waiting for SSH to be available..."
sleep 60

# Test SSH connection
echo "Testing SSH connection..."
for i in {1..10}; do
    if ssh -i "$(terraform output -raw private_key_path)" -o ConnectTimeout=10 -o StrictHostKeyChecking=no ubuntu@"$SERVER_IP" "echo 'SSH test successful'" 2>/dev/null; then
        echo "SSH connection established!"
        break
    fi
    echo "SSH attempt $i failed, retrying in 30 seconds..."
    sleep 30
done

# Run Ansible separately
echo "Running Ansible deployment..."
cd ../ansible
ansible-playbook -i inventory.ini site.yml -v

echo "Deployment completed successfully!"
echo "Application should be available at: http://$SERVER_IP"