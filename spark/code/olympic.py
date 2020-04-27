from pyspark.sql import SparkSession

input = "spark/dataset/olympic-games/summer.csv"  
spark = SparkSession.builder.appName("Olympic").getOrCreate()
dataset = spark.read.csv(input, header=True)

dataset.show()

dataset.groupBy('Year','Sport').count().collect()
spark.stop()