#!/bin/bash

# install python
sudo yum update -y &&
sudo yum install python3 -y &&
sudo yum install python3-pip -y &&
alias python=python3 ; alias pip=pip3 &&

# install python libs
pip install --upgrade pip && pip install requests &&
pip install python-dotenv &&

# install git and clone repo
sudo yum install -y git-all &&
git clone https://github.com/patrickhaley/GJG-GAM-Scripts.git &&
mv ec2_setup.sh ~./bin