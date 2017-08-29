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
library(ggplot2)
#read the data from the zip file

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#Take the subset of motor realted data from scc and NEI
BALAPM5<-NEI[which(NEI$fips=="24510" | NEI$fips=="06037"),]

motor<-SCC[grep("motor",SCC$SCC.Level.Three,ignore.case = TRUE),]
motor<-subset(BALAPM5, SCC %in% motor$SCC) 

#Aggregate the data by year
TotalPM<-aggregate(motor$Emissions,by=list(motor$year,motor$fips),sum)
names(TotalPM)<-c("year","fips","Emissions")

#Plotting
png("plot6.png", width=480, height=480)
g<-ggplot(TotalPM,aes(year,Emissions,color=fips))
g<-g+geom_point() #marking points
g<-g+geom_line(stat = "identity")+ labs(y="Emissions from motor vehicles for LA & Baltimore ",x="Year (1999,2002,2005,2008)")
#beautifying the plot
g<-g+theme_bw() +ggtitle("Motor vehicle-related sources for LA & Baltimore")+theme(
  plot.title = element_text(color="red", size=12, face="bold.italic"),
  axis.title.x = element_text(color="#993333", size=10, face="bold"),
  axis.title.y = element_text(color="#993333", size=10, face="bold")
)
g+scale_colour_discrete(name = "City", label = c("LA","Baltimore"))
dev.off()

