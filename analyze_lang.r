library(dplyr)

myFunction <- function(f) {
  d <- read.csv(f)
  lang1 <- d$lang[1]
  if(lang1=="Other (not listed)")
    lang1 <- d$lang_other[1]

  lang1
}

setwd("C:/Users/Joselyn/Documents/pitchdiffrove data/data")

filelist = list.files(pattern="*.csv$")

langs = lapply(filelist,myFunction)

setwd("C:/Users/Joselyn/Documents/pitchdiffrove data")

dt <- read.csv('dprimethreshold.csv')

all_data <- data.frame(dp=dt$dprime,threshold=dt$threshold,lang=matrix(unlist(langs),nrow=length(filelist),byrow=TRUE),stringsAsFactors = FALSE)

# number of participants per lang group
all_data%>%group_by(lang)%>%summarize(n=n())

# mean threshold and dp per lang group
all_data%>%group_by(lang)%>%summarize(threshold=mean(threshold),dp=mean(dp))

# participants with dp>2.5
all_data%>%filter(dp>2.5)%>%group_by(lang)