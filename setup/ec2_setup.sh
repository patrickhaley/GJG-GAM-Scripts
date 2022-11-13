#!/bin/bash

# install python
sudo yum update -y &&
sudo yum install python3 -y &&
sudo yum install python3-pip -y &&
alias python=python3 ; alias pip=pip3 &&

# install python libs
pip install --upgrade pip && pip install requests &&
pip install python-dotenv &&