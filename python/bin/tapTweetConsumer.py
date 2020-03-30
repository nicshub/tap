from kafka import KafkaConsumer
from json import loads
import mysql.connector
from mysql.connector import errorcode

DB_NAME='tap'
TABLE="CREATE TABLE `tweets` (`id` int(11) NOT NULL AUTO_INCREMENT,`tweet_id` varchar(250) DEFAULT NULL,`screen_name` varchar(128) DEFAULT NULL,`created_at` timestamp NULL DEFAULT NULL,`text` text,PRIMARY KEY (`id`))"

def create_database(cursor):
    try:
        cursor.execute("CREATE DATABASE {} DEFAULT CHARACTER SET 'utf8'".format(DB_NAME))
    except mysql.connector.Error as err:
        print("Failed creating database: {}".format(err))
        exit(1)

tweet_db_connection = mysql.connector.connect(host="localhost",user="root",passwd="tap")
cursor = tweet_db_connection.cursor()

# Connect or create tap DB
try:
    cursor.execute("USE {}".format(DB_NAME))
except mysql.connector.Error as err:
    print("Database {} does not exists.".format(DB_NAME))
    if err.errno == errorcode.ER_BAD_DB_ERROR:
        create_database(cursor)
        print("Database {} created successfully.".format(DB_NAME))
        cnx.database = DB_NAME
    else:
        print(err)
        exit(1)

consumer = KafkaConsumer(
    'tap',
     bootstrap_servers=['10.0.100.23:9092'],
     auto_offset_reset='earliest',
     enable_auto_commit=True,
     group_id='my-group',
     value_deserializer=lambda x: loads(x.decode('utf-8')))

for message in consumer:
    message = message.value 
    # collection.insert_one(message)

    print('{} added'.format(message))

cursor.close()
tweet_db_connection.close()