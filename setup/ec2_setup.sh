#!/bin/bash

# install python
sudo yum update -y &&
sudo yum install python3 -y &&
sudo yum install python3-pip -y &&

# install python libs
pip3 install --upgrade pip && pip3 install requests &&
pip3 install python-dotenv &&

#create aliases
alias python=python3 &&
alias pip=pip3