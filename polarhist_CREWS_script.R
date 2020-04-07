
# Polar histogram


library(likert)
library(reshape)
library(reshape2)
library(phenotypicForest)
library(readxl)


#Load data (format is questions in columns, raters in each row.) Data.frame with responses as factors. Full question as column headers.

qualtrics.terminology.Test<-read_excel("/Volumes/PSYHOME/PSYRES/pthompson/DVMB/CREWS_delphi/test data/CREWS_terminology.xlsx", sheet="CREWS_T")


##############################

#statements_R1_ind<-c(seq(20,157,3))
statements_T1_ind<-c(seq(8,39,2))
comments_ind_T<-c(seq(9,39,2))

contact.data.T<-qualtrics.terminology.Test[,1:6]
#add.info2<-qualtrics.data.Test2[,7:19]
#r.data<-
v.data.T<-comments.T<-data.frame(matrix(0, nrow = dim(qualtrics.terminology.Test)[1], ncol = 16))


# for(i in 1:46)
# {
#   r.data[,i]<-qualtrics.data.Test2[,statements_R1_ind[i]]
#   #colnames(r.data)[i]<-colnames(delphi.data2)[statements_R1_ind[i]]
# }
for(i in 1:16)
{
  v.data.T[,i]<-qualtrics.terminology.Test[,statements_T1_ind[i]]
  #colnames(v.data2)[i]<-colnames(delphi.data2)[statements_V1_ind[i]]
}
for(i in 1:16)
{
  comments.T[,i]<-qualtrics.terminology.Test[,comments_ind_T[i]]
  #colnames(comments)[i]<-colnames(delphi.data2)[comments_ind[i]]
}



##############################
QnamesT<-as.character(qualtrics.terminology.Test[,1])
delphi.Term.combine<-cbind(QnamesT,v.data.T)

delphi.Term.combine.N<-delphi.Term.combine[,-1]

for(i in 2:length(delphi.Term.combine)){delphi.Term.combine[,i]<-factor(delphi.Term.combine[,i])}

require(car)
require(gridExtra)
for(i in 2:length(delphi.Term.combine)){delphi.Term.combine[,i]<-car::recode(delphi.Term.combine[,i],"1='Strongly agree';2='Agree';3='Neutral';4='Disagree';5='Strongly disagree'")}


for(i in 2:length(delphi.Term.combine)){
  delphi.Term.combine[,i] = factor(delphi.Term.combine[,i],levels=c("Strongly agree","Agree", "Neutral","Disagree","Strongly disagree"),ordered=TRUE)
}
delphi.data2<-delphi.Term.combine


delphi.Terminology.statements<-read_excel("/Volumes/PSYHOME/PSYRES/pthompson/DVMB/CREWS_delphi/test data/delphi terminology statements.xlsx",sheet="delphi T statements2",stringsAsFactors =FALSE)
delphi.Terminology.statements<-delphi.Terminology.statements[1:16,1:2]

delphi.Term.combine<-delphi.Term.combine[,-1]

names(delphi.Term.combine)<-delphi.Terminology.statements[,2]

# delphi.combine$group<-factor(c(rep("Should we include this topic?",dim(r.data)[1]),rep("Do you agree with the statement?",dim(v.data2)[1])),levels=c("Should we include this topic?","Do you agree with the statement?"),ordered=TRUE)

delphi.Term.combine2<-cbind(contact.data.T$ExternalDataReference,delphi.Term.combine)
names(delphi.Term.combine2)[1]<-"username"

################################################
consensusT<-likert(delphi.Term.combine[,1:16])

consensusT$results$Item<-1:16
consensusT$results$Group<-rep("Item",16) 

consensusnewT<-melt(consensusT$results,c("Group","Item"),variable_name="score") # from wide to long  
names(consensusnewT)<-c("item","family","score","value")
consensusnewT<-consensusnewT[,c(2,1,3,4)]  
polhistT<-polarHistogram(consensusnewT,familyLabel=TRUE)

#windows()
polhist2<-(polhistT + scale_fill_brewer(name="Response", palette="RdYlBu") + theme(legend.position="top")) 

ggsave(polhist2,filename = '/Volumes/PSYHOME/PSYRES/pthompson/DVMB/CREWS_delphi/reports/polarhist_T.pdf')

##########################################################################################

#stacked barchart by discpline and country

stacked.dat.T<-read_excel("/Volumes/PSYHOME/PSYRES/pthompson/DVMB/CREWS_delphi/test data/crosstabsTerm.xlsx",sheet="Sheet1")


library(plyr)
stacked.dat.T<-stacked.dat.T[-c(61:66)]
stacked.dat.T <- ddply(stacked.dat.T, .(Discipline), transform, pos = cumsum(count) - (0.5 * count))
stacked.dat.T<-stacked.dat.T[-c(61:66)]
# plot bars and add text
library(car)
write.csv(stacked.dat.T,"/Volumes/PSYHOME/PSYRES/pthompson/DVMB/CREWS_delphi/test data/crosstabsTerm_new.xlsx")
#
stacked.dat.T<-read.csv("/Volumes/PSYHOME/PSYRES/pthompson/DVMB/CREWS_delphi/test data/crosstabsTerm_new.xlsx")

#windows()
barp1<-ggplot(data=stacked.dat.T, aes(x=Discipline, y=count, fill=Country)) +
  geom_bar(stat="identity")+ theme_minimal()+ theme(axis.text.x = element_text(angle = 90, hjust = 1)) + geom_text(aes(label = count, y = pos), size = 3) +
  coord_flip()

ggsave(barp1,filename = '/Volumes/PSYHOME/PSYRES/pthompson/DVMB/CREWS_delphi/reports/barplot1.pdf')