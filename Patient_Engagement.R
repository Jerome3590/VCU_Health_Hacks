
library(plumber)
library(lubridate)
library(rtweet)
library(tm)
library(wordcloud)
library(SnowballC)
library(RColorBrewer)
library(ggplot2)
library(caTools)
library(rpart)
library(rpart.plot)
library(caret)
library(dplyr)

setwd("~/")
#* @apiTitle Patient Engagement


tweets <- read.csv('~/elonmusk_tweets.csv', stringsAsFactors = FALSE, header = TRUE)


names(tweets) <- c("ID","Date","Tweet")
tweets <- select(tweets, Date, Tweet)
tweets$Date <- ymd_hms(tweets$Date)



# Create Corpus
tweet_corpus <- Corpus(VectorSource(tweets$Tweet))

# Review Corpus
tweet_corpus


# Create function to clean corpus
clean_corpus <- function(corp){
  corp <- tm_map(corp, content_transformer(tolower))
  corp <- tm_map(corp, removePunctuation)
  corp <- tm_map(corp, removeWords, c('apple', stopwords('en')))
  corp <- tm_map(corp, stemDocument)
}

# Apply function on corpus
clean_corp <- clean_corpus(tweet_corpus)

frequencies <- TermDocumentMatrix(clean_corp)

findFreqTerms(frequencies, lowfreq = 20)

findAssocs(frequencies, c('trip','kid','station'), corlimit = 0.4)


freq.matrix <- as.matrix(frequencies)
term.freq <- sort(rowSums(freq.matrix), decreasing = TRUE)
term.df <- data.frame(term=names(term.freq), freq=term.freq)


#' @get /barplot
#' @png
  function(){
    
    plot <- ggplot(subset(term.df, term.df$freq > 100 & term.df$freq < 200), aes(term, freq, fill=freq)) + geom_bar(stat='identity') + labs(x='Terms', y='Count', title='Term Frequencies') 
    
    print(plot + coord_flip())
    

}


#' @get /wordcloud
#' @png
  function(){
    
  wordcloud(term.df$term, term.df$freq, min.freq=45, max.words = 200, random.order = FALSE, colors= brewer.pal(8, 'Dark2'))
    
}


#library(gganatogram)
  
#* @get /patient_image
#* @serializer contentType list(type='image/png')
function(){
  
  file <- "patient_data_viz.PNG"
  
  readBin(file,'raw',n = file.info(file)$size)
  
}


#* @get /end_game
#* @serializer contentType list(type='image/png')
function(){
  
  file2 <- "end_game.PNG"
  
  readBin(file2,'raw',n = file.info(file2)$size)
  
}

