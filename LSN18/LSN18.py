from mysql.connector import connect

# Connect (more parameters are available)
cnx = connect(user='root', password='GYmnastics12***')

cursor = cnx.cursor()
parameters = {"username": "root"} # Dictionary
cursor.execute("CREATE USER %(username)s;", parameters)
cnx.commit() # Excute cursor transaction
cnx.close() # Close the connection