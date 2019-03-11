library(plyr)
library(dplyr)
require(tidyr)

# set your working directory (the files with fund codes and book call numbers should be located here)
setwd("XXXX")

# count how many numbers after decimal
decimalplaces <- function(x) {
  if (x %% 1 != 0) {
    pattern <- "^([0-9]+)[.]([0-9]+)$"
    #take the number formed from x using the 2nd part of the regex pattern
    dec_part <- gsub(pattern,"\\2", x)     
    #count the number of characters
    nchar(dec_part)
  } else { 
    return(0) 
  }
}

# read in your csv with fund codes (see sample)
myFundCodes<-read.csv("XXXX", header=T)

# loop to fill in numbers at end of call number - there's probably a cleaner way to do this
for(k in 1:length(myFundCodes$N2)){

  # if nothing after decimal at end of range, add 4 9s
  if(decimalplaces(myFundCodes$N2[k])==0){
    myFundCodes$N2[k]<-as.numeric(paste0(myFundCodes$N2[k], ".9999", collapse = "" ))
    # print(myFundCodes$N2[k])
  }
  # if fewer than 4 numbers after decimal at end of range, fill in with 9s
  else if(decimalplaces(myFundCodes$N2[k])<4){
    nines<-as.numeric(paste(rep(9, 4-decimalplaces(myFundCodes$N2[k])), collapse = ""))
    myFundCodes$N2[k]<-as.numeric(paste0(myFundCodes$N2[k], nines, collapse = "" ))
   # print(myFundCodes$N2[k])
  }

}

# read in your csv with books that you want to identify - I got data from Sirsi Workflows for all of my subject funds
myBookData<-read.csv("XXXX", header=T, fileEncoding="latin1")

# select the columns you want
myBookData<-subset(myBookData, select = c(fiscalcycle, vendorID, totalamtpaid, Title, Author, Publisher, X.050., X.090., FundID, FundCode))

# add new column for results called FundCodeBasedOnLC
myBookData$FundCodeBasedOnLC<-NA

# Replace NA (-) with blanks in call number columns, then merge those columns into one column. 
# This doesn't check for duplicates, so is a messy solution
myBookData$X.050. <- gsub("-","",myBookData$X.050.)
myBookData$X.090. <- gsub("-","",myBookData$X.090.)

myBookData <- myBookData %>% replace_na(list(X.050. = "", X.090. = "")) %>% unite(CallNumber, X.050., X.090., sep="")

#duplicate the call number column
myBookData$CallNumberBackup <- myBookData$CallNumber

#Split letters (LC Class) and numbers (with numbers after decimal) into two columns
myBookData <- myBookData %>% extract(CallNumberBackup, c("LCClass", "N"), "([[:alpha:]]+)([[:digit:]]+\\.*[[:digit:]]+)")

#convert all cutter numbers to number format
myBookData$N <- as.numeric(as.character(myBookData$N))
myFundCodes$N1 <- as.numeric(as.character(myFundCodes$N1))
myFundCodes$N2 <- as.numeric(as.character(myFundCodes$N2))

#loop through both datasets to assign fund codes - once again, probably a cleaner way to do this
for(i in 1:length(myBookData$LCClass)){
  for(j in 1:length(myFundCodes$LCClass)){
    if(identical(myBookData$LCClass[i], as.character(myFundCodes$LCClass[j]))){
      if(myBookData$N[i]>=myFundCodes$N1[j] && myBookData$N[i]<=myFundCodes$N2[j]){
        myBookData$FundCodeBasedOnLC[i]<-as.character(myFundCodes$SubjectCode[j])

      }
    }
  }
}

# sort that list by LC classification
 myBookData <- myBookData[order(myBookData$FundCode, myBookData$FundCodeBasedOnLC, myBookData$FundCodeBasedOnLC, myBookData$LCClass, myBookData$N),]

# pull out books that aren't in my fund codes and that do have an LC Class listed
for (i in 1:length(myBookData$FundCodeBasedOnLC)){
  bookAberrations<-myBookData[ which(is.na(myBookData$FundCodeBasedOnLC) & !is.na(myBookData$LCClass)), ]
}

# sort that list by LC classification
bookAberrations <- bookAberrations[order(bookAberrations$LCClass, bookAberrations$N),]



