setwd("ENTER YOUR WORKING DIRECTORY HERE")
getwd()
list.files()

#Import full list of Safari books using All Books Contained in Account Bookshelf report (csv)
listData<-read.csv("ALL_BOOKS_CONTAINED_IN_ACCOUNT_BOOKSHELF_REPORT.csv", header=T)

#Import usage data (converted from xsl to csv)
usageData<-read.csv("USAGE_REPORT.csv", header=T)

#Import notes
notes<-read.csv("NOTES_FILE.csv", header=T)

#Combine list and usage data by matching the title and keeping all entries in listData with all.x=true
myFullData<-merge(listData, usageData, by = "title", all.x = TRUE)

#Merge full data and notes by isbn
myFullData<-merge(myFullData, notes, by = "isbn", all.x = TRUE)

#remove columns don't want
myFullData<-subset(myFullData, select = -c(Book.DOI, Proprietary.Identifier, Publisher, ISBN, ISSN, book_points, points, X, title.y))

#sort by reporting period total
myFullData<-myFullData[order(-myFullData$Reporting.Period.Total),]

#Get current data from computer
currentDate<-Sys.Date()

#Set up file name that will use today's date
csvFileName<-paste("merged_data_",currentDate,".csv",sep="")

#Export merged data as a csv
write.csv(file=csvFileName, x=myFullData, row.names=FALSE)
