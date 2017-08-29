#This will setup the directory for the assignent, It will create directory, download the files from the web
# and will unzip the files to be use for the analysis
setwd("F:/Shared/Drive/AnjaliS/Coursera/ExpData/Week4")
mainDir<-getwd()
subDir<-"Course4Assignment2"
if (file.exists(subDir)){
  setwd(file.path(mainDir, subDir))
} else {
  dir.create(file.path(mainDir, subDir))
  setwd(file.path(mainDir, subDir))
  
}
#download the file and unzip into created folder
mDir<-paste(getwd(),"/Data_for_Peer_Assessment.zip",sep = "")
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if (!file.exists(mDir)){
  download.file(url, dest="Data_for_Peer_Assessment.zip", mode="wb") 
}
unzip ("Data_for_Peer_Assessment.zip", exdir=getwd())

#End

#read the data from the zip file

NEI <- readRDS("summarySCC_PM25.rds")
#Take the sum of PM values for all sources for each year
TotalPM<-aggregate(NEI$Emissions,by=list(NEI$year),sum)
#set up the columns names
names(TotalPM)<-c("Year","TotalEmissions")

#plot block, THis piece of code will plot the total emisisons against years

png("plot1.png", width=480, height=480)
plot(TotalPM,xaxt='n',yaxt='n',type="l",xlab="",ylab="")
par(new=TRUE)
plot(TotalPM,xaxt='n',yaxt='n',xlab="",ylab="",col="red",pch=19)#xaxt removes the labels

#setting up customs axes
axis(side=1,at=c(TotalPM$Year),cex=.5)
axis(side=2,at=c(TotalPM$TotalEmissions),labels=c("7332","5635","5454","3464"),las=1,cex=.5)  
title(main="Total PM5 Emisisons across years", col.main="red",
      xlab="Year", ylab="Total PM5(in 000s)",
      col.lab="blue")
dev.off()

