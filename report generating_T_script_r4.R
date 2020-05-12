#Load data from Qualtrics RECAP #
# Round 3 #
#04-05-2020#

setwd('/Volumes/PSYHOME/PSYRES/pthompson/DVMB/CREWS_delphi/')
library(readxl)
library(psych)
library(tools)

qualtrics.Terminology.data<-read_excel("/Volumes/PSYHOME/PSYRES/pthompson/DVMB/CREWS_delphi/test data/CREWS_terminology_r4.xlsx",sheet="CREWS_T")#,col_types='text')

qualtrics.Terminology.data<-as.data.frame(qualtrics.Terminology.data)

Delphi.T.members<-qualtrics.Terminology.data$ExternalDataReference
#Delphi.T.members <- factor(Delphi.T.members)
#Delphi.T.members <- factor(Delphi.T.members, levels=levels(droplevels(Delphi.T.members)))


processInput_T_Anon <- function(panel.member) { 
  temp <<- environment()
  Sweave(paste(getwd(),'/reports/delphi_CREWS_report_template_anonymous_r4.Rnw',sep=""), output = paste(getwd(),'/reports/Delphi_RECAP_report_anonymous_Round4.tex', sep = ''))
  texi2dvi(paste(getwd(),'/reports/Delphi_RECAP_report_anonymous_Round4.tex', sep = ''), pdf = TRUE, clean = TRUE,texinputs=paste(getwd(),'/reports/Delphi_RECAP_report_anonymous_Round4.tex', sep = ''))
}

# processInput_T <- function(panel.member) { 
#   temp <<- environment()
#   Sweave(paste(getwd(),'/reports/delphi_CREWS_report_template.Rnw',sep=""), output = paste(getwd(),'/reports/Delphi_CREWS_report_', panel.member, '.tex', sep = ''))
#   texi2dvi(paste(getwd(),'/reports/Delphi_CREWS_report_', panel.member, '.tex', sep = ''), pdf = TRUE, clean = TRUE,texinputs=paste(getwd(),'/reports/Delphi_CREWS_report_', panel.member, '.tex', sep = ''))
# }


for(panel.member in Delphi.T.members){
  Sweave(paste(getwd(),'/reports/delphi_CREWS_report_template_r4.Rnw',sep=""), output = paste(getwd(),'/reports/Delphi_RECAP_report_', panel.member, '_Round4.tex', sep = ''))
  texi2dvi(paste(getwd(),'/reports/Delphi_RECAP_report_', panel.member, '_Round4.tex', sep = ''), pdf = TRUE, clean = TRUE,texinputs=paste(getwd(),'/reports/Delphi_RECAP_report_', panel.member, '_Round4.tex', sep = ''))
}


##########################################################

# After omitting following IDs: c(11582826121, 11576211166, 11574988498, 11564087723, 11571347031, 11564508478)

qualtrics.Terminology.data<-read_excel("/Volumes/PSYHOME/PSYRES/pthompson/DVMB/CREWS_delphi/test data/CREWS_terminology_r4_omit_confused.xlsx",sheet="CREWS_T")#,col_types='text')

qualtrics.Terminology.data<-as.data.frame(qualtrics.Terminology.data)
Delphi.T.members<-qualtrics.Terminology.data$ExternalDataReference

processInput_T_Anon <- function(panel.member) { 
       temp <<- environment()
       Sweave(paste(getwd(),'/reports/delphi_CREWS_report_template_anonymous_r4_omit.Rnw',sep=""), output = paste(getwd(),'/reports/Delphi_RECAP_report_anonymous_Round4_omit.tex', sep = ''))
       texi2dvi(paste(getwd(),'/reports/Delphi_RECAP_report_anonymous_Round4_omit.tex', sep = ''), pdf = TRUE, clean = TRUE,texinputs=paste(getwd(),'/reports/Delphi_RECAP_report_anonymous_Round4_omit.tex', sep = ''))
