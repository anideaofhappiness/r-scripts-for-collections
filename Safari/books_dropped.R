setwd("ENTER YOUR WORKING DIRECTORY HERE")
getwd()
library(dplyr)

# Import current and older merged lists of books
booksMerged1<-read.csv("FILE_NAME_OLDER-DATE.csv", header=T)
booksMerged2<-read.csv("FILE_NAME_NEWER-DATE.csv", header=T)

# use dplyr function anti_join to make new dataframe of rows that are in first list but not second
booksDropped<-anti_join(booksMerged1, booksMerged2, by="isbn")

#keep only title, isbn, and publish date columns
booksDropped<-subset(booksDropped, select = c(title, isbn, publishing_date))

#Get current data from computer
currentDate<-Sys.Date()

#Set up file name that will use today's date
csvFileName<-paste("books_dropped_",currentDate,".csv",sep="")

#Export merged data as a csv
write.csv(file=csvFileName, x=booksDropped, row.names=FALSE)

