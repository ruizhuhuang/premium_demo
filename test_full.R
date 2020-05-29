#remove.packages("PReMiuM")
#detach("package:PReMiuM", unload=TRUE)
#install.packages("~/Documents/Dropbox_1/TACC/premium/PReMiuM_TACC_1/",repos=NULL, type="source")
rm(list = ls(all.names = TRUE))
#setwd("~/Documents/Dropbox_1/TACC/premium")
library(PReMiuM)
library(tidyverse)
library(data.table)
library(ConfigParser)

sessionInfo()

args = commandArgs(trailingOnly=TRUE)
config_file = args[1]
#config_file = "premium.config"


# config <- ConfigParser$new(init=c("bar"="Life", "baz"="too short"))
# config$set(option=c("a_bool", "a_float", "foo"), value=c("true", "3.1415", "%(bar)s is %(baz)s"),
#            section="Section 1", error_on_new_section=FALSE)

#config <- ConfigParser$new(init=c("bar"="Life", "baz"="too short"))
# config <- ConfigParser$new(Sys.getenv(), optionxform=identity)
# config$set(option=c("WorkDir", "Input_File_Name", "Output_Plot_Name"), 
#            value= c("/Users/rhuang/Documents/Dropbox_1/TACC/premium",  
#                     "sim_large_dataset_NormalMixed.dat",
#                     "summary_1_disc_9_cont_3.2.3.png"),
#            section="Runtime Settings", error_on_new_section=FALSE)
# 
# config$set(option=c("yModel", "xModel", "nSweeps", "nBurn", "nClusInit", "excludeY"), 
#            value= c("Normal", "Mixed",  "2000",     "1000",   "20",        "FALSE"   ),
#            section="profRegr Arguments", error_on_new_section=FALSE)
# 
# config$write(config_file)

config <- ConfigParser$new()
config = config$read(config_file)
section0 = "Runtime Settings"
WorkDir = config$get("WorkDir", NA, section0)
Input_File_Name = config$get("Input_File_Name", NA, section0)
Output_Plot_Name = config$get("Output_Plot_Name", NA, section0)

section1 = "profRegr Arguments"
yModel = config$get("yModel", NA, section1)
xModel = config$get("xModel", NA, section1)
nSweeps = as.integer(config$get("nSweeps", NA, section1))
nBurn = as.integer(config$get("nBurn", NA, section1))
nClusInit = as.integer(config$get("nClusInit", NA, section1))
excludeY = config$getboolean("excludeY", NA, section1)


setwd(WorkDir)
dataAll<-read.table(Input_File_Name,header = TRUE)

# config <- ConfigParser$new(Sys.getenv(), optionxform=identity)
# config$read(system.file("test.INI", package="ConfigParser"))



# test of the simulated data 

#install.packages("~/Documents/Dropbox_1/TACC/premium/PReMiuM_TACC_1/",repos=NULL, type="source")




cont_vars <- str_subset(names(dataAll), "Cont")[1:9]
disc_vars <- str_subset(names(dataAll), "Discr")[1]


set.seed(1234)
runInfoObj <- profRegr(outcome = 'outcome', yModel = yModel, xModel =xModel , 
                       discreteCovs = disc_vars, continuousCovs = cont_vars, 
                       data = dataAll, 
                       nSweeps = nSweeps, nBurn = nBurn, seed=123, nProgress = 100, 
                       nClusInit = nClusInit, excludeY=excludeY)

dissimObj<-calcDissimilarityMatrix(runInfoObj)
clusObj<-calcOptimalClustering(dissimObj)
riskProfileObj<-calcAvgRiskAndProfile(clusObj)
clusterOrderObj<-plotRiskProfile(riskProfileObj,Output_Plot_Name)

#write_rds(riskProfileObj, "riskProfObj.rds", compress = "xz")
