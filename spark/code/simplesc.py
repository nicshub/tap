import pyspark

conf = pyspark.SparkConf().setAppName('SimpleSC').setMaster('local')
sc = pyspark.SparkContext(conf=conf)
lotr1 = sc.textFile("spark/dataset/The Lord Of The Ring 1-The Fellowship Of The Ring_djvu.txt") 

sc.stop()