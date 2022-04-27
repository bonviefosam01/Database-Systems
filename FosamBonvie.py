from csv import DictReader
from mysql.connector import connect

# Set the root password for your local MySQL server here. When you turn in your
# file, make sure you set it back to 'it393'!
PASSWORD = 'GYmnastics12***'

# Create a connection to the database
cnx = connect(user='root', password=PASSWORD, database='wpr2')
cursor = cnx.cursor()

# Clear the existing records
cursor.execute('DELETE FROM registration;')
cursor.execute('DELETE FROM conference;')
cursor.execute('DELETE FROM attendee;')
cnx.commit()

# Here's the insertion command we will run for each record
INSERT = '''INSERT INTO attendee (emailAddress, lastName, firstName, creditCard)
VALUES (%(email)s, %(last_name)s, %(first_name)s, %(cardnum)s)'''

# Read the CSV file into a list of records (dictionaries)
CSV = 'records.csv'
with open(CSV) as f:
    records = DictReader(f)
    for record in records: # Loop through the records

        #### YOUR CODE HERE ####

        # 1. Split the "name" field in the record into two pieces (first and
        #    last names). Note that some last names have spaces inside! Save
        #    each part of the name back into the record with a new field name.
        record['first_name'] = record['first_name'].strip()
        record['last_name'] = record['last_name'].strip()
        new_list[i] = [record['first_name'], record['last_name']]

    
        # 2. If the credit card info is blank (an empty string), change it to
        #    None so that the value in MySQL will be NULL.
        try:
            record['cardnum'] = int(record['cardnum'])
        except:
            record['cardnum'] = None


        # Run the SQL command with the given record
        cursor.execute(INSERT, record)

cnx.commit() # Finalize the transaction

### CHECKS ###
fail = False

cursor.execute('SELECT * FROM attendee;')
results = cursor.fetchall()
if len(results) == 0:
    print('Failed insertion check; found no records!')
    fail = True

cursor.execute('SELECT * FROM attendee WHERE firstName IS NULL;')
results = cursor.fetchall()
if len(results) > 0:
    print('Failed name check; found record with no first name!')
    print('   ' + str(results[0]))
    fail = True

cursor.execute('SELECT * FROM attendee WHERE creditCard = "";')
results = cursor.fetchall()
if len(results) > 0:
    print('Failed card check; found record with empty string credit card!')
    print('   ' + str(results[0]))
    fail = True

cnx.close()  # Close the connection

if not fail:
    print("Checks pass")