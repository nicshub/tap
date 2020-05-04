from __future__ import print_function

import sys
import json
from pyspark import SparkContext
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils


sc = SparkContext(appName="PythonStreamingTwitter")

sc.setLogLevel("WARN")
ssc = StreamingContext(sc, 1)

brokers="10.0.100.23:9092"
topic = "tap"

kvs = KafkaUtils.createDirectStream(ssc, [topic], {"metadata.broker.list": brokers})
kvs.pprint()

tweets = kvs.map(lambda (key, value): json.loads(value)).map(lambda json_object: (json_object["user"]["screen_name"], json_object["text"]))

tweets.pprint()

ssc.start()
ssc.awaitTermination()
