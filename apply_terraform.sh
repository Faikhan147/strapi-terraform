#!/bin/bash
# run_terraform.sh
# Full automation for Terraform deployment

# Exit on error
set -e

# Go to Terraform directory (change if needed)
cd ~/strapi-terraform

echo "Initializing Terraform..."
terraform init

echo "Formatting Terraform files..."
terraform fmt

echo "Validating Terraform configuration..."
terraform validate

echo "Planning Terraform deployment..."
terraform plan -out=tfplan

# Ask user for confirmation before apply
read -p "Do you want to apply this Terraform plan? (yes/no): " confirm
if [ "$confirm" == "yes" ]; then
    echo "Applying Terraform plan..."
    terraform apply "tfplan"
else
    echo "Terraform apply cancelled."
    exit 1
fi

echo "Showing Terraform state..."
terraform show

echo "Displaying Terraform outputs..."
terraform output

echo "Terraform deployment completed successfully!"

kubectl get pods 
kubectl get svc
