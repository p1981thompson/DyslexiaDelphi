##################################################################
#                                                                #
# Script to send emails to Delphi panel with individual analyses #
#                                                                #
##################################################################

#07-04-2020#

#Required R libraries for mail#
install.packages("mailR")
install.packages("sendmailR")
library(mailR)
library(sendmailR)
library(readxl)
library(psych)

#delphi.data<-read.xlsx(paste(getwd(),"\\delphi data\\delphi_results.xlsx",sep=""),sheetName="Sheet1")

delphi.CREW.email.data<-read_excel("/Volumes/PSYHOME/PSYRES/pthompson/DVMB/CREWS_delphi/test data/CREWS_terminology.xlsx",sheet="CREWS_T")

Delphi.CREW.name<-apply(delphi.CREW.email.data[,c("firstname","lastname")], 1, paste, collapse=" ")
Delphi.members.CREW<-cbind(delphi.CREW.email.data[,1:5],Delphi.CREW.name)
for(i in 1:6){Delphi.members.CREW[,i]<-as.character(Delphi.members.CREW[,i])}

#####send result email with report (CREWS)#####

#for(i in 51:55)
  for(i in c(1:1))
{
  mailControl=list(smtpServer="smtp.ox.ac.uk")
  
  #key part for attachments, put the body and the mime_part in a list for msg
  attachmentObject <- mime_part(x=paste(getwd(),paste("/Delphi_CREWS_report_",Delphi.members.CREW[i,1],sep=""),".pdf",sep=""),name=paste("Delphi_CREW_report_",Delphi.members.CREW[i,1],".pdf",sep=""))
  #
  body = paste("Dear ", Delphi.members.CREW[i,6],", \n 
\n Many thanks for participating in CREWS Delphi study.
\n Enclosed is a report showing the summary findings together with an indication of where your responses fell in the distribution. 
\n \nBest wishes,
\n 
\nPaul Thompson
\n 
\nOn behalf of\n \n Professor Trish Greenhalgh,
             \nDept of Primary Care Health Sciences, University of Oxford, OX2 6GG.\ntel +44 (0)1865 289294",sep="")
  
  bodyWithAttachment <- list(body,attachmentObject)
  
  
  sendmail(from="paul.thompson@psy.ox.ac.uk",bcc="paul.thompson@psy.ox.ac.uk",to=Delphi.members.CREW[i,5],subject=paste("CREWS result: ", Delphi.members.CREW[i,6]),msg=bodyWithAttachment,control=mailControl)
}

################################################################



