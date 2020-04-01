# https://towardsdatascience.com/kafka-python-explained-in-10-lines-of-code-800e3e07dad
from kafka import KafkaConsumer
from json import loads

consumer = KafkaConsumer(
    'tap',
     bootstrap_servers=['kafkaServer:9092'],
     auto_offset_reset='latest',
     enable_auto_commit=True,
     group_id='my-group',
     value_deserializer=lambda x: loads(x.decode('utf-8')))

for message in consumer:
    message = message.value
    print('{} read'.format(message))