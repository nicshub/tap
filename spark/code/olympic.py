from pyspark.sql import SparkSession

input = "spark/dataset/olympic-games/summer.csv"  
spark = SparkSession.builder.appName("Olympic").getOrCreate()
dataset = spark.read.csv(input, header=True)

dataset.show()

group=dataset.groupBy('Year','Sport').count()
group.show()
spark.stop()