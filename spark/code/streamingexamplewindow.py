from pyspark import SparkContext
from pyspark.streaming import StreamingContext

# Create a local StreamingContext with two working thread and batch interval of 1 second
sc = SparkContext("local[2]", "NetworkWordCount")
ssc = StreamingContext(sc, 1)
ssc.checkpoint("checkpoint")
# Create a DStream that will connect to hostname:port, like localhost:9999
lines = ssc.socketTextStream("10.0.100.42", 9999)

# Split each line into words
words = lines.flatMap(lambda line: line.split(" "))

# Count each word in each batch
pairs = words.map(lambda word: (word, 1))
windowedWordCounts = pairs.reduceByKeyAndWindow(lambda x, y: x + y, lambda x, y: x - y, 30, 10)


# Print the first ten elements of each RDD generated in this DStream to the console
windowedWordCounts.pprint()

ssc.start()
ssc.awaitTermination()