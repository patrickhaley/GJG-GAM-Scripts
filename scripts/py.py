import os

from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())

print('All Group: ' + os.getenv('CA_GROUP_ALL'))
print('Master Group: ' + os.getenv('CA_GROUP_MASTERS'))