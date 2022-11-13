# GAM Script Toolbox
Collection of GAMADV-XTD3 scripts used and scheduled via CRON jobs to 
automate Google Workspace administrative tasks. These commands are based 
on https://github.com/taers232c/GAMADV-XTD3.

> DO NOT PASTE PRIVATE INFORMATION HERE!!!

# How to Use this Project
Scripts are modified and saved in "/home/patrick/bin/GAMScripts". Then they are scheduled as CRON jobs and accessed via "crontab -e". Each CRON job should append the job to /home/patrick/bin/GAMScripts/scheduled_tasks.log.

# Envionment Configuration
This assumes an EC2 instance has already been launched and the SSH Key Pair file has been downloaded. Replace PATH/TO/.PEM/FILE with the location of the Key Pair and INSTANCE_IPV4_ADDRESS with the IPv4 address of the instance.

1. Save SSH key pair file to .ssh

2. Connect to EC2 instance

3. Create file ec2_setup.sh and paste contents from setup file and execute it
```
bash ece_setup.sh
```
4. Rename .env.example file
```
mv .env.example .env
```
5. Install GAMADV-XTD3
```
bash /bin/gam_setup.sh
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

