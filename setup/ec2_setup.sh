#!/bin/bash

# Exit if any command fails
set -e

# Updating and Installing Python and its dependencies
echo "Updating system and installing Python and its dependencies..."
sudo yum update -y
sudo yum install -y python3

# Check if pip is installed, install if not
if ! command -v pip3 &> /dev/null; then
    sudo yum install -y python3-pip
fi

# Upgrade pip and install required Python libraries
echo "Installing required Python libraries..."
pip3 install --upgrade pip
pip3 install requests
pip3 install python-dotenv

# Set aliases for python and pip (they will only be available in new shell sessions)
echo "alias python=python3" >> ~/.bashrc
echo "alias pip=pip3" >> ~/.bashrc
source ~/.bashrc

echo "Python setup completed successfully."

# Load the .env file for AWS credentials
echo "Loading AWS credentials from .env file..."
set -a # automatically export all variables
source .env
set +a

# Installing AWS CLI
echo "Installing AWS CLI..."
if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo yum install -y unzip
    unzip awscliv2.zip
    sudo ./aws/install
fi

# Check AWS CLI version
aws --version

echo "AWS CLI installed successfully."

# Configure AWS Access Key, Secret Key
echo "Configuring AWS CLI with provided credentials..."
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
# Optionally set default region and output format
# aws configure set default.region your_default_region
# aws configure set default.output_format json

# Uncomment the following line if you want to run aws configure interactively for additional configuration
# aws configure

echo "AWS environment setup completed successfully."