#!/usr/bin/env python

import csv  # used for parsing the csv files we are importing
from datetime import datetime  # used to convert dates
from mysql.connector import connect  # needed to connect to database

_CSV = 'IT393_AY21-1_L18_ICE.csv'
_EXTRA = 'IT393_AY21-1_L18_ICE-Extra.csv'
_DB = 'it393_l18_ice'
_PASSWORD = 'GYmnastics12***'


# First part of ICE
# with open(_CSV, 'r') as csvFile:
#     for line in csvFile:
#         row = line.split(',')
#         print(row[1], row[2])

# Connect to the database
cnx = connect(user='root', password=_PASSWORD)
cursor = cnx.cursor()

# Create the database (drop existing database with same name)
cursor.execute("DROP DATABASE IF EXISTS {}".format(_DB))
cursor.execute(
    "CREATE DATABASE {} DEFAULT CHARACTER SET 'utf8'".format(_DB))
cursor.execute("USE {}".format(_DB))

# Create the table
TABLE = """CREATE TABLE person (
        id CHAR(10) NOT NULL,
        lastName CHAR(50) NOT NULL,
        firstName CHAR(50) NOT NULL,
        chineseName CHAR(1),
        email VARCHAR(50),
        gender CHAR(10) NOT NULL,
        joinDate DATE,
        customerValue FLOAT,
        visits INTEGER,
        PRIMARY KEY (id)
    );"""
cursor.execute(TABLE)

##triple quote allows for line breaks

# The insertion command
# The VALUES array will be filled in for each row, using the dictionary 
# key-value pairs created by the csv DictReader below.
_ROW = """INSERT INTO person (
        id,
        lastName,
        firstName,
        chineseName,
        email,
        gender,
        joinDate,
        customerValue,
        visits
    ) VALUES (
        %(id)s,
        %(last_name)s,
        %(first_name)s,
        %(chinese_name)s,
        %(email)s,
        %(gender)s,
        %(join_date)s,
        %(value)s,
        %(visits)s
    );"""

# Open the file, read each record iteratively, and insert to database
with open(_EXTRA, 'r', encoding='utf-8') as csvFile:
    csvData = csv.DictReader(csvFile)
    for r in csvData:

        # PARSE THE DATA HERE AS DESCRIBED IN THE ICE
        r['first_name'] = r['first_name'].strip()
        r['last_name'] = r['last_name'].strip()
        try:
            r['join_date'] = datetime.strptime(r['join_date'], '%d/%m/%Y')
        except:
            r['join_date'] = None
        try:
            r['visits'] = int(r['visits'])
        except:
            r['visits'] = None
        try:
            r['value'] = int(r['value'])
        except:
            r['value'] = None


        # Execute the insertion
        cursor.execute(_ROW, r)

# Commit the transaction
cnx.commit()

# Close the connection to the database
cnx.close()
