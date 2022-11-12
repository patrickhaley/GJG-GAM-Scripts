import csv
import sys

QUOTE_CHAR = '"' # Adjust as needed to properly read CSV files

SHOW_EMPTY_OUS = True # Should empty OUs be displayed
SHOW_LABELS = True # Should field labels be displayed
SELECTED_FIELDS = [] # Only display selected fields ['primaryEmail',] ['deviceId', 'notes']
FIELD_DELIMITER = ', '# Delimiter between fields
INDENT_SPACES = '  ' # How much to indent data
LINE_TERMINATOR = '\n' # On Windows, you probably want '\r\n'

orgUnits = ['/',]
orgUnitsTree = {'/': []}

if (len(sys.argv) > 3) and (sys.argv[3] != '-'):
  outputFile = open(sys.argv[3], 'w', newline='')
else:
  outputFile = sys.stdout

inputFile = open(sys.argv[1], 'r', encoding='utf-8')
inputCSV = csv.DictReader(inputFile, quotechar=QUOTE_CHAR)
inputFieldNames = inputCSV.fieldnames
if 'orgUnitPath' not in inputFieldNames:
  sys.stderr.write(f'Error: no header orgUnitPath in Org Units file {sys.argv[1]} field names: {",".join(inputFieldNames)}\n')
  sys.exit(1)
for row in inputCSV:
  orgUnits.append(row['orgUnitPath'])
  orgUnitsTree[row['orgUnitPath']] = []
inputFile.close()

if sys.argv[2] != '-':
  inputFile = open(sys.argv[2], 'r', encoding='utf-8')
else:
  inputFile = sys.stdin
inputCSV = csv.DictReader(inputFile, quotechar=QUOTE_CHAR)
inputFieldNames = inputCSV.fieldnames
if inputFieldNames is None:
  sys.stderr.write(f'Error: no headers in Data file {sys.argv[2]}\n')
  sys.exit(2)
if SELECTED_FIELDS:
  fieldNames = []
  for field in SELECTED_FIELDS:
    if field not in inputFieldNames:
      sys.stderr.write(f'Error: selected field {field} is not in Data file {sys.argv[2]} field names: {",".join(inputFieldNames)}\n')
      sys.exit(3)
    fieldNames.append(field)
else:
  fieldNames = inputFieldNames[:]
  fieldNames.remove('orgUnitPath')
if 'orgUnitPath' not in inputFieldNames:
  sys.stderr.write(f'Error: no header orgUnitPath in Data file {sys.argv[2]} field names: {",".join(inputFieldNames)}\n')
  sys.exit(4)
for row in inputCSV:
  if row['orgUnitPath'] is not None:
    orgUnitsTree[row['orgUnitPath']].append(row)
if inputFile != sys.stdin:
  inputFile.close()

for orgUnitPath in orgUnits:
  count = len(orgUnitsTree[orgUnitPath])
  if SHOW_EMPTY_OUS or count > 0:
    outputFile.write(f'{orgUnitPath}: {count}\n')
    if count > 0:
      for child in orgUnitsTree[orgUnitPath]:
        if SHOW_LABELS:
          outputFile.write(INDENT_SPACES+FIELD_DELIMITER.join([f'{field}: {child[field]}' for field in fieldNames])+LINE_TERMINATOR)
        else:
          outputFile.write(INDENT_SPACES+FIELD_DELIMITER.join([child[field] for field in fieldNames])+LINE_TERMINATOR)
if outputFile != sys.stdout:
  outputFile.close()