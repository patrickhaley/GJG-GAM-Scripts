# This in in progress; not working yet

import os
import csv
import subprocess
from dotenv import load_dotenv

# Load .env file
load_dotenv()

# Access variables
aws_account_id = os.getenv('AWS_ACCOUNT_ID')
group_name = os.getenv('GROUP_NAME')

# Define the CSV file path
csv_file_path = 'path_to_your_csv_file.csv'

# Open the CSV file
with open(csv_file_path, newline='') as csvfile:
    reader = csv.DictReader(csvfile)

    for row in reader:
        member_name = row['member_name_column']  # Replace with the actual column name
        group_name = 'YourGroupName'  # Replace with your group name
        aws_account_id = '111122223333'  # Replace with your AWS account ID
        namespace = 'default'

        # Construct the AWS CLI command
        command = [
            'aws', 'quicksight', 'create-group-membership',
            '--aws-account-id', aws_account_id,
            '--namespace', namespace,
            '--group-name', group_name,
            '--member-name', member_name
        ]

        # Execute the command
        try:
            subprocess.run(command, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error adding {member_name} to group: {e}")

# You can add more error handling and logging as needed.
