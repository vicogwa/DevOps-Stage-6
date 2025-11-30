# Infrastructure Setup

This directory contains the infrastructure as code (IaC) and automation for deploying the microservices TODO application.

## Prerequisites

1. **AWS Account** with appropriate permissions
2. **Terraform** (v1.5.0 or later)
3. **Ansible** (v2.9 or later)
4. **AWS CLI** configured with credentials
5. **SSH Key Pair** in AWS

## Quick Start

### 1. Configure Terraform Variables

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

Edit `terraform/terraform.tfvars` with your AWS configuration:

```hcl
aws_region = "us-east-2"
instance_type = "t3.medium"
key_name = "your-aws-key-pair-name"
private_key_path = "/path/to/your/private/key.pem"
```

### 2. Deploy Infrastructure

**Linux/macOS:**
```bash
chmod +x deploy.sh
./deploy.sh
```

**Windows:**
```cmd
deploy.bat
```

**Manual Terraform:**
```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

## Components

### Terraform (`terraform/`)
- **main.tf**: Core infrastructure resources (EC2, Security Groups)
- **variables.tf**: Input variables
- **outputs.tf**: Output values
- **inventory.tpl**: Ansible inventory template

### Ansible (`ansible/`)
- **site.yml**: Main playbook
- **roles/dependencies/**: Installs Docker, Docker Compose, Git
- **roles/deploy/**: Deploys the application

### CI/CD (`.github/workflows/`)
- **infrastructure.yml**: Infrastructure deployment with drift detection
- **application.yml**: Application deployment on code changes

## Features

### Drift Detection
- Automatically detects infrastructure changes
- Sends email notifications when drift is found
- Requires manual approval for changes
- Proceeds automatically if no drift detected

### Idempotent Deployment
- Re-running deployment does nothing unless changes exist
- No resource recreation unless drift occurs
- Application restarts only if code changed

### Security
- HTTPS with automatic SSL certificates
- Security groups with minimal required ports
- SSH key-based authentication

## Environment Variables (GitHub Secrets)

For CI/CD, configure these secrets in your GitHub repository:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_KEY_NAME
PRIVATE_KEY_PATH
PRIVATE_KEY
EMAIL_USERNAME
EMAIL_PASSWORD
NOTIFICATION_EMAIL
```

## Troubleshooting

### Common Issues

1. **Terraform state bucket doesn't exist**
   - Create an S3 bucket for Terraform state
   - Update the bucket name in `main.tf`

2. **SSH connection fails**
   - Verify key pair exists in AWS
   - Check private key path and permissions
   - Ensure security group allows SSH (port 22)

3. **Application not accessible**
   - Check security group allows HTTP/HTTPS (ports 80/443)
   - Verify Docker containers are running
   - Check application logs

### Logs and Debugging

```bash
# Check Terraform state
cd terraform
terraform show

# Check Ansible logs
cd ansible
ansible-playbook -i inventory.ini site.yml -v

# Check application status on server
ssh -i /path/to/key.pem ubuntu@<server-ip>
docker ps
docker-compose logs
```

## Architecture

The infrastructure creates:
- 1x EC2 instance (t3.medium)
- Security group with ports 22, 80, 443
- Automatic Ansible provisioning
- Docker-based application deployment
- Traefik reverse proxy with SSL

## Cleanup

To destroy the infrastructure:

```bash
cd terraform
terraform destroy
```