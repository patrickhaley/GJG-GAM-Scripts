# GJG GAM Script Toolbox

This repository contains a collection of GAMADV-XTD3 scripts designed to automate Google Workspace administrative tasks. These scripts are intended to be scheduled via CRON jobs. The commands are based on [GAMADV-XTD3](https://github.com/taers232c/GAMADV-XTD3).

> **Warning**: DO NOT PASTE PRIVATE INFORMATION HERE!!!

## How to Use this Project

Scripts are stored and modified in `/home/ec2-user/GJG-GAM-Scripts`. They are scheduled as CRON jobs and managed via `crontab -e`. Each CRON job should append its output to `/home/ec2-user/GJG-GAM-Scripts/scheduled_tasks.log`.

## Infrastructure Setup

1. Launch an Amazon EC2 instance using the Linux 2 AMI. The free tier is sufficient for this application.
2. Save the SSH key pair file to your `.ssh` directory.
3. Connect to the EC2 instance using SSH.

## Environment Configuration

1. Clone this repository on your EC2 instance:
```
git clone https://github.com/patrickhaley/GJG-GAM-Scripts.git
```
2. Run `setup.sh` to configure the environment. This script will install and set up Python, AWS CLI, GAMADV-XTD3, and other necessary components:
```
bash GJG-GAM-Scripts/setup.sh
```
3. Edit `gam.cfg` to add configurations for other workspace customers/regions if necessary.
4. Rename `.env.example` file to `.env` and update it with your AWS and Google Workspace credentials:
```
mv /home/ec2-user/GJG-GAM-Scripts/.env.example /home/ec2-user/GJG-GAM-Scripts/.env
```
5. Customize the environment as needed for your specific Google Workspace and AWS configurations.

## Additional Information

- The `setup.sh` script significantly simplifies the initial setup by automating several steps, including the installation of GAMADV-XTD3. It also configures Python, AWS CLI, and creates necessary directories and configurations for GAM.
- For specific CRON job setups, refer to your server's CRON documentation and the specific requirements of your scripts.