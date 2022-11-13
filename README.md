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
5. Create GAMwork and edit gam.config
```
bash GJG-GAM-Scripts/setup/gam_setup.sh
```
6. Rename .env.example file
```
mv GJG-GAM-Scripts/.env.example GJG-GAM-Scripts/.env
```

# Configure CI/CD Pipeline
1. Make .ssh directory.
```
sudo mkdir ~/.ssh
```
2. Give permissions to www user.
```
sudo chown -R www-data:www-data ~/.ssh
```
3. Generate SSH key.
```
sudo -Hu www-data ssh-keygen -t rsa
```
4. Give the SSH Key a name
```
key_name
```
5. Leave all other fields empty until randomart image is generated then display the key.
```
sudo cat .ssh/key_name.pub
```
6. Copy the SSH key.
7. Navigate to GitHub repo and click Settings > Deploy keys
8. Give the key a title, paste the SSH key into the field, and click Save.
9. Navigate back to the server and view html folder.
```
cd /home/user_directory
```
10. Give folder permissions to www user.

