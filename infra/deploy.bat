@echo off

echo Starting infrastructure deployment...

REM Check if terraform.tfvars exists
if not exist "terraform\terraform.tfvars" (
    echo Error: terraform\terraform.tfvars not found!
    echo Please copy terraform.tfvars.example to terraform.tfvars and configure it.
    exit /b 1
)

REM Navigate to terraform directory
cd terraform

REM Initialize Terraform
echo Initializing Terraform...
terraform init

REM Plan infrastructure changes
echo Planning infrastructure changes...
terraform plan -out=tfplan

REM Apply infrastructure changes
echo Applying infrastructure changes...
terraform apply -auto-approve tfplan

echo Infrastructure deployment completed successfully!
terraform output server_public_ip