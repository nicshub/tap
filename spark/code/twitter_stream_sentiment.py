from __future__ import print_function

import sys
import json
from pyspark import SparkContext
from pyspark.sql.session import SparkSession
from pyspark.streaming import StreamingContext
import pyspark
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
print(os.path.realpath(__file__))

import sys
reload(sys)
sys.setdefaultencoding('utf-8')
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
sc = SparkContext(appName="Tweet")
spark = SparkSession(sc)

sc.setLogLevel("WARN")
# read the dataset  
training_set = spark.read.csv('../tap/spark/dataset/training_set_sentipolc16.csv',
                         schema=schema,
                         header=True,
                         sep=',')
training_set                        


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
    print("********************")
    tweet=rdd.map(lambda (key, value): json.loads(value)).map(lambda json_object: json_object["text"])
    tweetstr=tweet.collect()
    if not tweetstr:
        print("No Tweet")
        return
    
    print("********************")
    print(tweetstr)
    # create a dataframe with column name 'tweet' and each row will contain the tweet
    rowRdd = tweet.map(lambda w: Row(tweet=w))
    # create a spark dataframe
    wordsDataFrame = spark.createDataFrame(rowRdd)
    # transform the data using the pipeline and get the predicted sentiment
    pipelineFit.transform(wordsDataFrame).select('tweet','prediction').show(truncate=False)

brokers="10.0.100.23:9092"
topic = "tap"

ssc = StreamingContext(sc, 1)
kvs = KafkaUtils.createDirectStream(ssc, [topic], {"metadata.broker.list": brokers})

# get the predicted sentiments for the tweets received
kvs.foreachRDD(get_prediction_json)

#tweets.pprint()

ssc.start()
ssc.awaitTermination()
