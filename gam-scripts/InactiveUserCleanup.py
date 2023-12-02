# README for Inactive User Notification Script
#
# This script is designed to send automated emails to users of G.J. Gardner Homes' 
# Google accounts who have been inactive. It identifies inactive users based on 
# their last login time or account creation time, then sends a personalized email 
# urging them to log in to prevent account deactivation.
#
# Requirements:
# - Python 3.x
# - pytz library for timezone management
# - A CSV file named 'inactive_users.csv' containing primaryEmail, lastLoginTime, and creationTime.
# - GAMADV-XTD3 (Google Apps Manager) installed and configured for sending emails.
#
# Usage:
# 1. Ensure GAM is correctly set up and the path to the GAM executable is correctly specified in the 'gam_path' variable.
# 2. Replace 'csv_file_path' with the correct path to the 'inactive_users.csv' file.
# 3. Optionally, modify the email content and subject in the script.
# 4. Run the script. It will process each user in the CSV file and send emails as needed.
#
# Note:
# - The script uses Python's datetime and pytz libraries to handle dates and timezones.
# - The email message is in HTML format for better formatting and readability.
# - Replace placeholders like SEND_FROM_NAME, SEND_FROM_EMAIL, and BCC_EMAIL with actual email addresses before running the script.

import csv
import os
from datetime import datetime
import pytz

# Define paths to the GAM executable and CSV file containing user data
gam_path = os.path.expanduser("~/gamadv-xtd3/gam") # Replace with path to GAM
csv_file_path = os.path.expanduser('~/GAMWork/inactive_users.csv') # Replace with path to CSV

def parse_date(date_str):
    """
    Converts a date string to a datetime object.
    If the date string is 'Never', it returns None.
    Otherwise, it assumes the date is in ISO format, removes the 'Z' (UTC) suffix, and adds UTC timezone.
    """
    if date_str == "Never":
        return None
    return datetime.fromisoformat(date_str.rstrip("Z")).replace(tzinfo=pytz.utc)

def calculate_days_difference(date):
    """
    Calculates the number of days between the given date and today.
    If the provided date is None, it returns None.
    """
    if not date:
        return None
    today = datetime.now(pytz.utc)
    difference = today - date
    return difference.days

# Open and read the CSV file containing user data
with open(csv_file_path, newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # Extract user data from each row
        primary_email = row['primaryEmail']
        last_login_date = parse_date(row['lastLoginTime'])
        creation_date = parse_date(row['creationTime'])

        # Calculate days since last login and account creation
        daysSinceLogin = calculate_days_difference(last_login_date)
        daysSinceCreation = calculate_days_difference(creation_date)

        # Compose different messages based on user activity
        if last_login_date is None:
            message = f"We've noticed that your G.J. Gardner Google account has not been accessed since its creation {daysSinceCreation} days ago."
        else:
            message = f"We've noticed that your G.J. Gardner Google account has not been accessed in {daysSinceLogin} days."

        # Full HTML message to be sent
        full_message = f"""<html><head><title>Action Required to Maintain Your G.J. Gardner Google Account</title><style>body{{font-family: sans-serif, Arial;}}.email-container{{margin: 20px auto; text-align: left; color: #172024; font-size: 1.2em; width: 600px;}}</style></head><body><div class=\"email-container\"><br><img src=\"https://media.gjgardner.com/wp-content/uploads/2019/09/01175101/logo-large.png\" style='max-height: 30px;'><br><br><br>Dear {primary_email},<br><br>{message}<br><br>As part of our commitment to safeguarding user privacy and data security, we are scheduled to automatically deactivate inactive accounts.<br><br><strong>Important Action Required:</strong><br>To prevent the deactivation of your account, scheduled for December 10, 2023, please log into your account as soon as possible. This will ensure the continued accessibility and preservation of your account and associated data.<br><br><strong>What Happens If You Don't Log In:</strong><br>If no action is taken by the scheduled date:<br><ul><li>Your account will be deactivated.</li><li>All files and data will be securely archived.</li><li>Ownership of all Google Drive files will be transferred to the Franchise Owner.</li></ul>We understand the importance of the data and files in your account. By taking prompt action, you can secure their continued availability under your control.<br><br><strong>Need Assistance?</strong><br>Our Support Team is here to help. If you have any questions or require assistance with accessing your account, please don't hesitate to contact us.<br><br>Thank you for your prompt attention to this matter.<br><br>Kind regards,<br><br>G.J. Gardner IT Support</div></body></html>"""

        # Send the email using GAM
        os.system(f"{gam_path} user {primary_email} sendemail from \"'SEND_FROM_NAME' <SEND_FROM_EMAIL>\" bcc BCC_EMAIL subject \"Action Required to Maintain Your G.J. Gardner Google Account\" message \"{full_message}\" html") 
        # Replace SEND_FROM_NAME, SEND_FROM_EMAIL, and BCC_EMAIL with your actual email addresses