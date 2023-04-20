#DIRECTORY SETTING
print(utils::getSrcDirectory(function(){}))
print(utils::getSrcFilename(function(){}, full.names = TRUE))
directory <- setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
data_directory <- gsub("/scripts", "/data/",directory)


getwd()
file.path()


name_tbl_cours<-paste(data_directory,"tbl_cours.csv",sep="")
name_tbl_etudiants<-paste(data_directory,"tbl_etudiants.csv",sep="")
name_tbl_collaborations<-paste(data_directory,"tbl_collaborations.csv",sep="")
