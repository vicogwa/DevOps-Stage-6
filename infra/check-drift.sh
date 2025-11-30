#!/bin/bash

set -e

echo "Checking for infrastructure drift..."

cd terraform

# Initialize Terraform
terraform init

# Run plan to check for drift
terraform plan -detailed-exitcode -no-color

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ No drift detected - infrastructure is up to date"
elif [ $EXIT_CODE -eq 2 ]; then
    echo "⚠️  Infrastructure drift detected!"
    echo "Run 'terraform apply' to fix the drift"
    exit 2
else
    echo "❌ Error occurred during drift check"
    exit 1
fi