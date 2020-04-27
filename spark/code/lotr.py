import pyspark
import nltk
from nltk.corpus import stopwords
import string

# word tokenizer
def word_tokenize1(x):
    import nltk
    x = x.lower()
    return nltk.word_tokenize(x)

conf = pyspark.SparkConf().setAppName('Lotr').setMaster('local')
sc = pyspark.SparkContext(conf=conf)
lotr1 = sc.textFile("spark/dataset/The Lord Of The Ring 1-The Fellowship Of The Ring_djvu.txt") 

lotr1_words = lotr1.flatMap(word_tokenize1)

lotr1_words.take(40)


stop_words=set(stopwords.words('english'))
lotr1_words_filtered = lotr1_words.filter(lambda word : word[0] not in stop_words and word[0] != '')

lotr1_words_filtered.take(10)

list_punct='!()-[]{};:\'"\,<>./?@#$%^&*_~“’`'
lotr1_words_filtered_np = lotr1_words_filtered.filter(lambda punct : punct not in list_punct)

lotr1_words_filtered_np.take(10)

text_Classifi = lotr1_words_filtered_np.flatMap(lambda x : nltk.FreqDist(x.split(",")).most_common()).map(lambda x: x).reduceByKey(lambda x,y : x+y).sortBy(lambda x: x[1], ascending = False)
topcommon_data = text_Classifi.take(100) #take first 100 most common words

print(topcommon_data);
sc.stop()