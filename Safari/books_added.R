setwd("ENTER YOUR WORKING DIRECTORY HERE")
getwd()

#Import list of Safari books added
booksAdded<-read.csv("SAFARI_BOOKS_ADDED_REPORT.csv", header=T)

#remove columns don't want
booksAdded<-subset(booksAdded, select = -c(account_id, account_name, X))

# add proxy to URLs
booksAdded<-as.data.frame(lapply(booksAdded, function(x) {gsub("http://techbus.safaribooksonline.com", "ENTER_YOUR_PROXY_SERVER_PREFIX_HERE?url=http://proquestcombo.safaribooksonline.com", x)}))

#Get current data from computer
currentDate<-Sys.Date()

#Set up file name that will use today's date
csvFileName<-paste("books_added_",currentDate,".csv",sep="")

#Export merged data as a csv
write.csv(file=csvFileName, x=booksAdded, row.names=FALSE)