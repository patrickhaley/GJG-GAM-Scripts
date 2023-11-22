import os
from dotenv import load_dotenv, find_dotenv

# This in in progress; not working yet

load_dotenv(find_dotenv())

print('All Group: ' + os.getenv('CA_GROUP_ALL'))
print('Master Group: ' + os.getenv('CA_GROUP_MASTERS'))