# Load the required functions and packages
source('create_model_input.R')
library('e1071')
library("optparse")
library('rkafka')
library('rjson')
library('stringi')

# Load features
features <- readRDS('features.rds')

# Load the model
model <- readRDS('svm.rds')

consumer=rkafka.createConsumer("10.0.100.22:2181","tap")

while(1)
{
  tweet=rkafka.read(consumer)
  #print(tweet)
  if (tweet != "") { 
    tweetObj=fromJSON(tweet)
    tweetText=stri_enc_toascii(tweetObj$text)
    print(tweetText)
    # Transform raw Text into input suitable for our model
    input_data <- create_model_input(features, tweetText)
    # Make prediction
    prediction=predict(model, newdata=input_data)
    predictionValue=as.String(prediction)
    print("Prediction")
    print(predictionValue)
  }
}
rkafka.closeConsumer(consumer)