import csv
import os
from datetime import datetime
import pytz

from dotenv import load_dotenv

# Load .env file
load_dotenv()

# Define paths
gam_path = os.path.expanduser("~/gamadv-xtd3/gam")
csv_file_path = os.path.expanduser('~/GAMWork/inactive_users.csv')

def parse_date(date_str):
    if date_str == "Never":
        return None
    # Make the datetime object offset-aware by adding UTC timezone
    return datetime.fromisoformat(date_str.rstrip("Z")).replace(tzinfo=pytz.utc)

def calculate_days_difference(date):
    if not date:
        return None
    today = datetime.now(pytz.utc)
    difference = today - date
    return difference.days

# with open('./GAMWork/inactive_users.csv', newline='') as csvfile:
with open(csv_file_path, newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        primary_email = row['primaryEmail']
        last_login_date = parse_date(row['lastLoginTime'])
        creation_date = parse_date(row['creationTime'])

        daysSinceLogin = calculate_days_difference(last_login_date)
        daysSinceCreation = calculate_days_difference(creation_date)

        if last_login_date is None:
            message = f"We've noticed that your G.J. Gardner Google account has not been accessed since its creation {daysSinceCreation} days ago."
        else:
            message = f"We've noticed that your G.J. Gardner Google account has not been accessed in {daysSinceLogin} days."

        full_message = f"<html><head><title>Action Required to Maintain Your G.J. Gardner Google Account</title><style>body{{font-family: sans-serif, Arial;}}.email-container{{margin: 20px auto; text-align: left; color: #172024; font-size: 1.2em; width: 600px;}}</style></head><body><div class=\"email-container\"><br><img src=\"https://media.gjgardner.com/wp-content/uploads/2019/09/01175101/logo-large.png\" style='max-height: 30px;'><br><br><br>Dear {primary_email},<br><br>{message}<br><br>As part of our commitment to safeguarding user privacy and data security, we are scheduled to automatically deactivate inactive accounts.<br><br><strong>Important Action Required:</strong><br>To prevent the deactivation of your account, scheduled for December 10, 2023, please log into your account as soon as possible. This will ensure the continued accessibility and preservation of your account and associated data.<br><br><strong>What Happens If You Don't Log In:</strong><br>If no action is taken by the scheduled date:<br><ul><li>Your account will be deactivated.</li><li>All files and data will be securely archived.</li><li>Ownership of all Google Drive files will be transferred to the Franchise Owner.</li></ul>We understand the importance of the data and files in your account. By taking prompt action, you can secure their continued availability under your control.<br><br><strong>Need Assistance?</strong><br>Our Support Team is here to help. If you have any questions or require assistance with accessing your account, please don't hesitate to contact us.<br><br>Thank you for your prompt attention to this matter.<br><br>Kind regards,<br><br>G.J. Gardner IT Support</div></body></html>"

        os.system(f"{gam_path} user {primary_email} sendemail from FROM_EMAIL bcc BCC_EMAIL subject \"Action Required to Maintain Your G.J. Gardner Google Account\" message \"{full_message}\" html")
