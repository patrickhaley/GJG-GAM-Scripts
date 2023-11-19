#!/bin/bash

# This script automates the setup of an Amazon EC2 instance for managing Google Workspace accounts using GAMADV-XTD3 and AWS QuickSight.
# It performs the following functions:
# 1. Updates the system and installs Python along with necessary dependencies.
# 2. Optionally sets up Python and pip aliases for convenience.
# 3. Installs or updates the AWS CLI and allows the user to configure the AWS region.
# 4. Installs or updates GAMADV-XTD3, a command-line tool for Google Workspace administration.
# Usage: Run this script as a superuser on an Amazon EC2 instance to prepare the environment for Google Workspace and AWS management.

# Exit if any command fails
set -e

# Function to ask for confirmation (Y/N)
confirm_action() {
    read -p "$1 (Y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Updating and Installing Python and its dependencies
if confirm_action "Do you want to update the system and install Python and its dependencies?"; then
    echo
    echo "Updating system and installing Python and its dependencies..."
    echo
    sudo yum update -y
    sudo yum install -y python3
    if ! command -v pip3 &> /dev/null; then
        sudo yum install -y python3-pip
    fi
    echo
    echo "Installing required Python libraries..."
    echo
    pip3 install --upgrade pip
    pip3 install requests
    pip3 install python-dotenv
    echo
    echo "Python setup completed successfully."
    echo
fi

# Adding Python aliases
echo
if confirm_action "Do you want to add Python and Pip aliases to your .bashrc?"; then
    echo "alias python=python3" >> ~/.bashrc
    echo "alias pip=pip3" >> ~/.bashrc
    echo
    echo "Aliases added to .bashrc successfully."
    echo
fi

# Change to home directory
cd ~/.

# Load the .env file for AWS credentials
echo
echo "Loading AWS credentials from .env file..."
echo
set -a
source ~/GJG-GAM-Scripts/.env
set +a

# Installing or Updating AWS CLI
if command -v aws &> /dev/null; then
    echo "AWS CLI is already installed. Current version:"
    aws --version
    echo
    if confirm_action "Do you want to update AWS CLI?"; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        sudo yum install -y unzip
        unzip -o awscliv2.zip
        sudo ./aws/install --update
    fi
else
    if confirm_action "AWS CLI is not installed. Do you want to install it?"; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        sudo yum install -y unzip
        unzip awscliv2.zip
        sudo ./aws/install
    fi
fi

# Configure AWS Access Key, Secret Key
echo
echo "Configuring AWS CLI with provided credentials..."
echo
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure set region us-east-1

# Configure AWS region
# echo "Select a region for AWS CLI:"
# echo
# echo "1) default"
# echo "2) ap-southeast-2"
# echo "3) us-east-1"
# echo
# read -p "Enter your choice (1, 2, or 3): " region_choice

# case $region_choice in
#     1) aws configure set region "default" ;;
#     2) aws configure set region "ap-southeast-2" ;;
#     3) aws configure set region "us-east-1" ;;
#     *) echo "Invalid selection. No changes made to the region." ;;
# esac

echo
echo "AWS configuration completed successfully."
echo

# Adding AWS aliases
if confirm_action "Do you want to add QuickSight aliases to your .bashrc?"; then
    echo "alias qs='aws quicksight'" >> ~/.bashrc
    # Use a function to dynamically get AWS_ACCOUNT_ID from aws sts get-caller-identity
    echo 'set_idns_alias() {' >> ~/.bashrc
    echo '    local AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)' >> ~/.bashrc
    echo '    alias idns="--aws-account-id $AWS_ACCOUNT_ID --namespace default"' >> ~/.bashrc
    echo '}' >> ~/.bashrc
    echo 'set_idns_alias' >> ~/.bashrc
    echo
    echo "QuickSight aliases added to .bashrc successfully."
fi

# # Setting up GAM
# if confirm_action "Do you want to install or update GAM?"; then
#     if command -v gam &> /dev/null; then
#         if confirm_action "GAM is already installed. Do you want to upgrade it?"; then
#             gam config no_browser true save
#             gam update project
#         fi
#     else
#         bash <(curl -s -S -L https://raw.githubusercontent.com/taers232c/GAMADV-XTD3/master/src/gam-install.sh)
#     fi
#     echo "GAM setup completed successfully."
# fi

source ~/.bashrc
echo
echo "EC2 and GAM environment setup completed successfully."