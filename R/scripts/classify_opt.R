#!/Library/Frameworks/R.framework/Versions/3.6/Resources/bin/Rscript
# To be executed as a script from terminal


# set the path
#setwd('/Users/xiaobu/Teaching/2019_TAP/script/')
#
# Load the required functions and packages
source('create_model_input.R')
library('e1071')
library("optparse")
#
# Arguments
option_list = list(
  make_option(c("-m", "--model"), type="character", default='model.rds', 
              help="model file name  [default= %default]", metavar="character"),
  make_option(c("-f", "--features"), type="character", default="features.rds", 
              help="features file name [default= %default]", metavar="character"),
  make_option(c("-t", "--text"), type="character", default='Il governo italiano sta andando alla grande!', 
              help="tweet text  [default= %default]", metavar="character")
)
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)
# Sanity check
if (is.null(opt$text)){
  print_help(opt_parser)
  #stop("At least one argument must be supplied (input file).\n", call.=FALSE)
  stop("At least one argument must be supplied (input text).\n", call.=FALSE)
}

# Create Text to analyse
tweet = opt$text
# Load features
features <- readRDS(opt$features)
# Transform raw Text into input suitable for our model
input_data <- create_model_input(features, tweet)
# Load the model
model <- readRDS(opt$model)
# Make prediction
predict(model, newdata=input_data)
