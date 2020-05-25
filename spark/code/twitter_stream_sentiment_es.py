from __future__ import print_function

import sys
import json
from pyspark import SparkContext
from pyspark.sql.session import SparkSession
from pyspark.streaming import StreamingContext
import pyspark
from pyspark.conf import SparkConf
from pyspark import SparkContext
from pyspark.sql.session import SparkSession
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils
import pyspark.sql.types as tp
from pyspark.ml import Pipeline
from pyspark.ml.feature import StringIndexer, OneHotEncoderEstimator, VectorAssembler
from pyspark.ml.feature import StopWordsRemover, Word2Vec, RegexTokenizer
from pyspark.ml.classification import LogisticRegression
from pyspark.sql import Row
from pyspark.ml.feature import HashingTF, IDF, Tokenizer
from pyspark.ml.classification import NaiveBayes
from pyspark.ml.evaluation import MulticlassClassificationEvaluator
import os
import sys

reload(sys)
# Set encoding to UTF
sys.setdefaultencoding('utf-8')


brokers="10.0.100.23:9092"
topic = "tap"
elastic_host="10.0.100.51"
elastic_index="twitter"
elastic_document="_doc"

es_write_conf = {
# specify the node that we are sending data to (this should be the master)
"es.nodes" : elastic_host,
# specify the port in case it is not the default port
"es.port" : '9200',
# specify a resource in the form 'index/doc-type'
"es.resource" : '%s/%s' % (elastic_index,elastic_document),
# is the input JSON?
"es.input.json" : "yes"
}

## is there a field in the mapping that should be used to specify the ES document ID
# "es.mapping.id": "id"
# Define Training Set Structure
tweetSchema = tp.StructType([
    # Todo use proper timestamp
    tp.StructField(name= 'timestamp', dataType= tp.LongType(),  nullable= True),
    tp.StructField(name= 'tweet',      dataType= tp.StringType(),  nullable= True)
])

schema = tp.StructType([
    tp.StructField(name= 'id', dataType= tp.StringType(),  nullable= True),
    tp.StructField(name= 'subjective',       dataType= tp.IntegerType(),  nullable= True),
    tp.StructField(name= 'positive',       dataType= tp.IntegerType(),  nullable= True),
    tp.StructField(name= 'negative',       dataType= tp.IntegerType(),  nullable= True),
    tp.StructField(name= 'ironic',       dataType= tp.IntegerType(),  nullable= True),
    tp.StructField(name= 'lpositive',       dataType= tp.IntegerType(),  nullable= True),
    tp.StructField(name= 'lnegative',       dataType= tp.IntegerType(),  nullable= True),
    tp.StructField(name= 'top',       dataType= tp.IntegerType(),  nullable= True),
    tp.StructField(name= 'tweet',       dataType= tp.StringType(),   nullable= True)
])

# Create Spark Context
sc = SparkContext(appName="Tweet")
spark = SparkSession(sc)

sc.setLogLevel("WARN")

# Elastic Search
conf = SparkConf(loadDefaults=False)
conf.set("es.index.auto.create", "true")

# read the dataset  
training_set = spark.read.csv('../tap/spark/dataset/training_set_sentipolc16.csv',
                         schema=schema,
                         header=True,
                         sep=',')

# define stage 1: tokenize the tweet text    
stage_1 = RegexTokenizer(inputCol= 'tweet' , outputCol= 'tokens', pattern= '\\W')
# define stage 2: remove the stop words
stage_2 = StopWordsRemover(inputCol= 'tokens', outputCol= 'filtered_words')
# define stage 3: create a word vector of the size 100
stage_3 = Word2Vec(inputCol= 'filtered_words', outputCol= 'vector', vectorSize= 100)
# define stage 4: Logistic Regression Model
model = LogisticRegression(featuresCol= 'vector', labelCol= 'positive')
# setup the pipeline
pipeline = Pipeline(stages= [stage_1, stage_2, stage_3, model])

# fit the pipeline model with the training data
pipelineFit = pipeline.fit(training_set)

modelSummary=pipelineFit.stages[-1].summary
modelSummary.accuracy

def get_prediction_json(key,rdd):
    #print(rdd.collect())
    print("********************")
    tweet=rdd.map(lambda (key, value): json.loads(value)).map(
        lambda json_object: (
            json_object["text"].encode('utf-8'), 
            long(json_object["timestamp_ms"])
        )
    )
    tweetstr=tweet.collect()
    if not tweetstr:
        print("No Tweet")
        return
    
    print("********************")
    print(tweetstr)
    # create a dataframe with column name 'tweet' and each row will contain the tweet
    rowRdd = tweet.map(lambda t: Row(tweet=t[0],timestamp=t[1]))
    # create a spark dataframe
    wordsDataFrame = spark.createDataFrame(rowRdd,schema=tweetSchema)
    wordsDataFrame.show(truncate=False)
    # transform the data using the pipeline and get the predicted sentiment
    data=pipelineFit.transform(wordsDataFrame)
    data.show()
    new = data.rdd.map(lambda item: {'timestamp': item['timestamp'],'tweet': item['tweet'], 'sentiment':item['prediction']})
    final_rdd = new.map(json.dumps).map(lambda x: ('key', x))
    print(final_rdd.collect())
    final_rdd.saveAsNewAPIHadoopFile(
    path='-',
    outputFormatClass="org.elasticsearch.hadoop.mr.EsOutputFormat",
    keyClass="org.apache.hadoop.io.NullWritable",
    valueClass="org.elasticsearch.hadoop.mr.LinkedMapWritable",
    conf=es_write_conf)

ssc = StreamingContext(sc, 1)
kvs = KafkaUtils.createDirectStream(ssc, [topic], {"metadata.broker.list": brokers})

# get the predicted sentiments for the tweets received
kvs.foreachRDD(get_prediction_json)

mapping = {
    "mappings": {
        "properties": {
            "timestamp": {
                "type": "date"
            }
        }
    }
}

from elasticsearch import Elasticsearch
elastic = Elasticsearch(hosts=[elastic_host])

# make an API call to the Elasticsearch cluster
# and have it return a response:
response = elastic.indices.create(
    index=elastic_index,
    body=mapping,
    ignore=400 # ignore 400 already exists code
)

if 'acknowledged' in response:
    if response['acknowledged'] == True:
        print ("INDEX MAPPING SUCCESS FOR INDEX:", response['index'])

# catch API error response
elif 'error' in response:
    print ("ERROR:", response['error']['root_cause'])
    print ("TYPE:", response['error']['type'])

ssc.start()
ssc.awaitTermination()
