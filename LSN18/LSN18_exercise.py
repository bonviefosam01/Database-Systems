#with open("IT393_AY21-1_L18_ICE.csv") as f:
   # for line in f:
    #    fields = line.split(',')
      #  print(fields[1], fields[2])

import csv
from datetime import datetime

with open("IT393_AY21-1_L18_ICE.csv") as f:
    data = csv.DictReader(f)
    for record in data:
      record['first_name'] = record['first_name'].strip()
      record['last_name'] = record['last_name'].strip()
      try:
        record['join_date'] = datetime.strptime(record['join_date'],'%d/%m/%Y')
      except:
        record['join_date'] = None
      try:
        record['value'] = float(record['value'])
      except:
        record['value'] = None
      try:
        record['visits'] = int(record['value'])
      except:
        record['visits'] = None

      print(record)

      #print(record['first_name'], record['last_name'])