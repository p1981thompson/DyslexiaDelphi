
# Polar histogram


library(likert)
library(reshape)
library(reshape2)
library(phenotypicForest)
library(readxl)

consensusT<-likert(delphi.Term.combine[,1:13])

consensusT$results$Item<-1:13
consensusT$results$Group<-rep("Item",13) 

consensusnewT<-melt(consensusT$results,c("Group","Item"),variable_name="score") # from wide to long  
names(consensusnewT)<-c("item","family","score","value")
consensusnewT<-consensusnewT[,c(2,1,3,4)]  
polhistT<-polarHistogram(consensusnewT,familyLabel=TRUE)

#windows()
print(polhistT + scale_fill_brewer(name="Response", palette="RdYlBu") + theme(legend.position="top")) 

##########################################################################################

#stacked barchart by discpline and country

stacked.dat.T<-read_excel("H:/DVMB/CREWS_delphi/test data/crosstabsTerm.xlsx",sheet="Sheet1")


library(plyr)
stacked.dat.T<-stacked.dat.T[-c(61:66)]
stacked.dat.T <- ddply(stacked.dat.T, .(Discipline), transform, pos = cumsum(count) - (0.5 * count))
stacked.dat.T<-stacked.dat.T[-c(61:66)]
# plot bars and add text
library(car)
write.csv(stacked.dat.T,"H:/DVMB/CREWS_delphi/test data/crosstabsTerm_new.xlsx")
#
stacked.dat.T<-read.csv("H:/DVMB/CREWS_delphi/test data/crosstabsTerm_new.xlsx")

#windows()
ggplot(data=stacked.dat.T, aes(x=Discipline, y=count, fill=Country)) +
  geom_bar(stat="identity")+ theme_minimal()+ theme(axis.text.x = element_text(angle = 90, hjust = 1)) + geom_text(aes(label = count, y = pos), size = 3) +
  coord_flip()

