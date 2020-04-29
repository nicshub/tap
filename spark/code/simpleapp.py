from pyspark.sql import SparkSession

logFile = "spark/dataset/lotr_characters.csv"  # Should be some file on your system
spark = SparkSession.builder.appName("SimpleApp").getOrCreate()
logData = spark.read.text(logFile).cache()

male = logData.filter(logData.value.contains('Male')).count()
female = logData.filter(logData.value.contains('Female')).count()
numTot = logData.count()
print("Lines with a: %i, lines with b: %i" % (male, female))
print("Tot number %d" % (numTot))
spark.stop()