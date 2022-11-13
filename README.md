# GAM Script Toolbox
Collection of GAMADV-XTD3 scripts used and scheduled via CRON jobs to 
automate Google Workspace administrative tasks. These commands are based 
on https://github.com/taers232c/GAMADV-XTD3.

> DO NOT PASTE PRIVATE INFORMATION HERE!!!

# How to Use this Project
Scripts are modified and saved in "/home/patrick/bin/GAMScripts". Then they are scheduled as CRON jobs and accessed via "crontab -e". Each CRON job should append the job to /home/patrick/bin/GAMScripts/scheduled_tasks.log.

# Infrastructure Setup
1. Launch an an Amazon EC2 instance using the Linux 2 AMI; Free tier is fine for this application.
2. Save SSH key pair file to .ssh
3. Connect to the EC2 instance

# Envionment Configuration
1. Install git
```
sudo yum install -y git-all
```
2. Clone this repo
```
git clone https://github.com/patrickhaley/GJG-GAM-Scripts.git
```
3. Run ec2_setup.sh to configure the environment
```
bash GJG-GAM-Scripts/setup/ec2_setup.sh
```
4. Install GAMADV-XTD3 (https://github.com/taers232c/GAMADV-XTD3)
```
bash <(curl -s -S -L https://raw.githubusercontent.com/taers232c/GAMADV-XTD3/master/src/gam-install.sh)
```
```
gam info domain
```
5. Run gam_setup.sh to create GAMwork and gam config directories
```
bash GJG-GAM-Scripts/setup/gam_setup.sh
```
6. Edit gam.cfg to add other customers/regions
7. Rename .env.example file
```
mv /home/ec2-user/GJG-GAM-Scripts/.env.example GJG-GAM-Scripts/.env
```