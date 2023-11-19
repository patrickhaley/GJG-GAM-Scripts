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
    echo "Updating system and installing Python and its dependencies..."
    sudo yum update -y
    sudo yum install -y python3
    if ! command -v pip3 &> /dev/null; then
        sudo yum install -y python3-pip
    fi
    echo "Installing required Python libraries..."
    pip3 install --upgrade pip
    pip3 install requests
    pip3 install python-dotenv
    echo "Python setup completed successfully."
fi

# Change to home directory
cd /home/ec2-user

# Load the .env file for AWS credentials
echo "Loading AWS credentials from .env file..."
set -a
source /home/ec2-user/GJG-GAM-Scripts/.env
set +a

# Extract AWS_ACCOUNT_ID from .env file
AWS_ACCOUNT_ID=$(grep 'AWS_ACCOUNT_ID' /home/ec2-user/GJG-GAM-Scripts/.env | cut -d '=' -f2)

# Installing or Updating AWS CLI
if command -v aws &> /dev/null; then
    echo "AWS CLI is already installed. Current version:"
    aws --version
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

# Configure AWS region
current_region=$(aws configure get region)
echo "Current AWS region is: $current_region"
echo "1) Default"
echo "2) us-east-1"
echo "3) ap-southeast-2"
read -p "Select region (1/2/3): " region_choice
case $region_choice in
    2) aws configure set region us-east-1 ;;
    3) aws configure set region ap-southeast-2 ;;
    *) echo "Keeping the default region." ;;
esac

# Setting up GAM
if confirm_action "Do you want to install or update GAM?"; then
    if command -v gam &> /dev/null; then
        if confirm_action "GAM is already installed. Do you want to upgrade it?"; then
            gam config no_browser true save
            gam update project
        fi
    else
        bash <(curl -s -S -L https://raw.githubusercontent.com/taers232c/GAMADV-XTD3/master/src/gam-install.sh)
    fi
    echo "GAM setup completed successfully."
fi

# Adding aliases and functions
if confirm_action "Do you want to add Python and Pip aliases to your .bashrc?"; then
    echo "alias python=python3" >> ~/.bashrc
    echo "alias pip=pip3" >> ~/.bashrc
fi

if confirm_action "Do you want to add QuickSight aliases to your .bashrc?"; then
    echo "alias qs='aws quicksight'" >> ~/.bashrc
    echo "alias idns='--aws-account-id $AWS_ACCOUNT_ID --namespace default'" >> ~/.bashrc
fi

source ~/.bashrc

echo "EC2 and GAM environment setup completed successfully."