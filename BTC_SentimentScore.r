library(twitteR)
library(ROAuth)
library(XML)
library(tm)
library(rtweet)
library(dplyr)
library(syuzhet)
library(ggplot2)
consumer_key <- "nrSclT1cP9IPpxHnCAJoBApyu"
consumer_secret <-"UHvi66waigPJFFkFkIf1oVJthz1mBsIZrWjyxGZ5igvuhItwOV"
# configure RCurl options
RCurlOptions <- list(capath=system.file("CurlSSL", "cacert.pem", package = "RCurl"), ssl.verifypeer = FALSE)
options(RCurlOptions = RCurlOptions)

# setup twitter using Oauth
setup_twitter_oauth(consumer_key, consumer_secret)

tweet.collection=read.csv("/home/qubaic/AnalyticsVidhya/Coinberg/bitcoin_tweets.csv")
#etherum.collection <- searchTwitter('etherum', lang = "en",limit=2000)
#tweet.collection <- searchTwitter(args[1], lang = "en",since="2018-06-01",until = "2018-04-01",include_rts = FALSE,retryonratelimit = TRUE)
#tweet.collection <- search_tweets(args[1], n=100000,lang = "en",include_rts = FALSE,retryonratelimit = TRUE)
dim(tweet.collection)
length(tweet.collection)
class(tweet.collection)
length(tweet.collection) # actual number of retrieved tweets
head(tweet.collection, 2)
tweetFrame=as.data.frame(tweet.collection)
str(tweetFrame)
table(as.Date(tweetFrame$created_at))
tweetFrame$created_at=as.Date(tweetFrame$created_at)
tweetFrame$text=as.character(tweetFrame$text)
head(tweetFrame,1)
summary(tweetFrame)
names(tweetFrame)
dim(tweetFrame)
#write.csv(tweetFrame, file = "bitcoin_tweets.csv")
#remove URLs
tweetFrame$text <- gsub("http[[:alnum:][:punct:]]*", "", tweetFrame$text) 
tweetFrame$text[20]
#remove all non alphanumerics
tweetFrame$text <- gsub("[^0-9A-Za-z///' ]", "", tweetFrame$text)
tweetFrame$text[20]
# Remove empty tweets (onyl URL tweets)
tweetFrame <- tweetFrame[tweetFrame$text != "", ] 
tweetFrame$text[20]
dim(tweetFrame)
# Convert to lower case
tweetFrame$text <- tolower(tweetFrame$text)
tweetFrame$text[20]
# Remove stop words
myStopWords <- c(stopwords('english'), "rt")
tweetFrame$text <- gsub(paste0("\\b(",paste(myStopWords, collapse="|"),")\\b"), "", tweetFrame$text)
tweetFrame$text[20]
# Remove empty tweets (onyl URL tweets)
tweetFrame <- tweetFrame[tweetFrame$text != "", ] 
names(tweetFrame)
#tweetFrame=read.csv("/home/qubaic/AnalyticsVidhya/Coinberg/Bitcoin_6_9.csv")
word.df=as.vector(tweetFrame$text)
#emotion.df <- get_nrc_sentiment(word.df)
#??get_sentiments
#installed.packages("syuzhet")
#library("syuzhet")
#emotion.df2 <- cbind(tweetFrame$text, emotion.df) 

#head(emotion.df2)
tweetFrame$Score <- get_sentiment(word.df)

#most.positive <- word.df[sent.value == max(sent.value)]
#tweetFrame$created_at
twt=tweetFrame[which(tweetFrame$created_at>'2018-05-01'),]
dim(twt)
tail(twt[,c(2,4)],20)
#twt[,list(mean=mean(Score)),by=created_at]
output=aggregate(twt$Score, by=list(twt$created_at), FUN=mean)
output=as.data.frame(output)
colnames(output)=c("Date","Score")
ggplot(output,aes(Date,Score))+geom_line()
#abline(1,1)
#plot(tweetFrame$created_at[which(tweetFrame$created_at>'2018-05-01')],sent.value[which(tweetFrame$created_at>'2018-05-01')])
#outputfile=cbind.data.frame(tweetFrame$created_at[which(tweetFrame$created_at>'2018-05-01')],sent.value[which(tweetFrame$created_at>'2018-05-01')])
write.csv(output,"/home/qubaic/AnalyticsVidhya/Coinberg/BTC_Sentiment.csv",row.names=FALSE)              
