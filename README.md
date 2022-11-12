# GAM Script Toolbox
Collection of GAMADV-XTD3 scripts used and scheduled via CRON jobs to 
automate Google Workspace administrative tasks. These commands are based 
on https://github.com/taers232c/GAMADV-XTD3.

> DO NOT PASTE PRIVATE INFORMATION HERE!!!

# How to Use this Project
Scripts are modified and saved in "/home/patrick/bin/GAMScripts". Then they are scheduled as CRON jobs and accessed via "crontab -e". Each CRON job should append the job to /home/patrick/bin/GAMScripts/scheduled_tasks.log.

# Envionment Configuration
1. Install Python3 and pip
```
sudo apt install python3
```
```
sudo apt install python3-pip
```
2. Create aliases for python and pip
```
alias python=python3 ; alias pip=pip3
```
3. Install python-dotenv
```
sudo pip install python-dotenv
```
4. Install git
```
sudo apt install git-all
```
5. Clone repo to directory
6. Rename '.env.example' to '.env' and add environment variables
7. Set up Deploy Github Hook 