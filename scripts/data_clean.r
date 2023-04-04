#Denya Berard
#Marie-Christine Arsenault  
#Philippe Barrette
#Roxanne Bernier

#DIRECTORY SETTING
print(utils::getSrcDirectory(function(){}))
print(utils::getSrcFilename(function(){}, full.names = TRUE))
directory <- setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
data_directory <- gsub("/scripts", "/data/",directory)
getwd()
file.path()

#PACKsAGES
library(RSQLite)
#library(RSQLite, dependencies= TRUE)

#INDEXATION DES DONN�ES
allFiles <- dir(data_directory)
tabNames <- c('collaboration', 'cour', 'etudiant')
nbGroupe <- length(grep(tabNames[1], allFiles))

for(tab in tabNames){
  tabFiles <- allFiles[grep(tab, allFiles)]
    for(groupe in 1:nbGroupe){
    tabName <- paste0(tab, "_",groupe)
        ficher <- paste0(data_directory, tabFiles[groupe])
        L <- readLines(ficher, n = 1)
    separateur <- ifelse(grepl(';', L), ';', ',')
    assign(tabName, read.csv(ficher, sep = separateur, stringsAsFactors = FALSE))
    }
}

#EFFACEMENT DES OBJETS
rm(list = c('allFiles', 'tab', 'tabFiles', 'tabName', 'ficher', 'groupe'))
#rm(list = ls(all = TRUE))

#CORRECTION DES DONN�ES DES TABLES DE COLLABORATION
collaboration_7 <- subset(collaboration_7,select=(-(5:9)))
collaboration_4 <- subset(collaboration_4[-c(109,290:292,431), ])

for (i in 1:nrow(collaboration_4)) {
  for(j in 1:ncol(collaboration_4)) {
    collaboration_4[i,3][collaboration_4[i,3]==""] <- "ECL615"
    collaboration_4[i,4][collaboration_4[i,4]==""] <- "E2022"
  }
}

#CORRECTION DES DONN�ES DES TABLES DE COURS
cour_5 <-subset(cour_5[-c(28), ])
cour_5 <- subset(cour_5,select=(-(4:9)))
cour_6 <-subset(cour_6[-c(13:235), ])
cour_7 <-subset(cour_7[-c(13:235), ])
cour_7 <- subset(cour_7,select=(-(4:9)))
cour_10 <- subset(cour_10[-c(25:29), ])
names(cour_4)[names(cour_4) =="?..sigle"]<-"sigle"

#CORRECTION DES DONN�ES DES TABLES D'�TUDIANTS
etudiant_3 <- subset(etudiant_3,select=(-(9:9)))
etudiant_4 <- subset(etudiant_4,select=(-(9:9)))
etudiant_5 <- subset(etudiant_5,select=(-(9:9)))
etudiant_7 <- subset(etudiant_7,select=(-(9:9)))
etudiant_9 <- subset(etudiant_9,select=(-(9:9)))
etudiant_6 <- subset(etudiant_6[-c(52:59), ])
names(etudiant_4)[names(etudiant_4) =="prenom_nom."]<-"prenom_nom"

#CR�ATION DES 3 TABLES FINALES
etudiants <- rbind(etudiant_1, etudiant_2, etudiant_3, etudiant_4, etudiant_5,etudiant_6,etudiant_7,etudiant_8,etudiant_9,etudiant_10)
cours <-rbind(cour_1, cour_2, cour_3, cour_4, cour_5,cour_6,cour_7,cour_8,cour_9,cour_10)
collaboration <-rbind(collaboration_1, collaboration_2, collaboration_3, collaboration_4, collaboration_5,collaboration_6,collaboration_7,collaboration_8,collaboration_9,collaboration_10)

#DESTRUCTION DES DONN�ES DUPLIQU�ES
cours<-cours[!duplicated(cours), ]
etudiants<-etudiants[!duplicated(etudiants), ]
collaboration<-collaboration[!duplicated(collaboration), ]

#CORRECTION DE LA TABLE COLLABORATION
##NOMS
for (i in 1:nrow(collaboration)) {
  for(j in 1:ncol(collaboration)) {
  collaboration[i,j][collaboration[i,j]=="marie_eve_gagne"] <- "marie-eve_gagne"
  }
}
for (i in 1:nrow(collaboration)) {
  for(j in 1:ncol(collaboration)) {
    collaboration[i,j][collaboration[i,j]=="philippe_barette"] <- "philippe_barrette"
  }
}
collaboration$etudiant1 <- gsub('yannick_sageau', 'yanick_sageau', collaboration$etudiant1)
collaboration$etudiant2 <- gsub('yannick_sageau', 'yanick_sageau', collaboration$etudiant2)
###SYMBOLES
install.packages("tidyverse")
library(tidyverse)
for(col in names(etudiants)){
  collaboration[,col] <- str_replace_all(collaboration[,col],pattern="\\s",replacement="")
}
for(col in names(etudiants)){
  collaboration[,col] <- str_replace_all(collaboration[,col],pattern="<a0>",replacement="")
}
for(col in names(etudiants)){
  collaboration[,col] <- str_replace_all(collaboration[,col],pattern="�",replacement="")
}

#CORRECTION DE LA TABLE �TUDIANTS
##NOMS
etudiants$prenom_nom <- gsub('yannick_sageau', 'yanick_sageau', etudiants$prenom_nom)
etudiants$prenom <- gsub('yannick', 'yanick', etudiants$prenom)
etudiants$prenom_nom <- gsub('yanick_sagneau', 'yanick_sageau', etudiants$prenom_nom)
etudiants$nom <- gsub('sagneau', 'sageau', etudiants$nom)
etudiants$region_administrative <- gsub('bas-st-laurent', 'bas-saint-laurent', etudiants$region_administrative)
etudiants$prenom_nom <- gsub('peneloppe_robert', 'penelope_robert', etudiants$prenom_nom)
etudiants$prenom <- gsub('peneloppe', 'penelope', etudiants$prenom)
etudiants$prenom_nom <- gsub('louis-phillippe_theriault', 'louis-philippe_theriault', etudiants$prenom_nom)
etudiants$prenom <- gsub('louis-phillipe', 'louis-philippe', etudiants$prenom)
etudiants$prenom_nom <- gsub('phillippe_bourassa', 'philippe_bourassa', etudiants$prenom_nom)
etudiants$prenom_nom <- gsub('sabrina_leclerc', 'sabrina_leclercq', etudiants$prenom_nom)
etudiants$nom <- gsub('leclerc', 'leclercq', etudiants$nom)
etudiants$prenom_nom <- gsub('catherine_viel_lapointe', 'catherine_viel-lapointe', etudiants$prenom_nom)
etudiants$nom <- gsub('viel_lapointe', 'viel-lapointe', etudiants$nom)
etudiants$prenom_nom <- gsub('marie_christine_arseneau', 'marie-christine_arseneau', etudiants$prenom_nom)
etudiants$prenom <- gsub('marie_christine', 'marie-christine', etudiants$prenom)
etudiants$region_administrative <- gsub('gaspesie_iles_de_la_madeleine', 'gaspesie_iles-de-la-madeleine', etudiants$region_administrative)
etudiants$prenom_nom <- gsub('kayla_trempe_kay', 'kayla_trempe-kay', etudiants$prenom_nom)
etudiants$nom <- gsub('trempe_kay', 'trempe-kay', etudiants$nom)
etudiants$prenom <- gsub('cassandre', 'cassandra', etudiants$prenom)
etudiants$prenom_nom <- gsub('philippe_barette', 'philippe_barrette', etudiants$prenom_nom)
etudiants$prenom_nom <- gsub('margerite_duchesne', 'marguerite_duchesne', etudiants$prenom_nom)
etudiants$prenom_nom <- gsub('mael_guerin', 'mael_gerin', etudiants$prenom_nom)
etudiants$nom <- gsub('guerin', 'gerin', etudiants$nom)
etudiants$prenom_nom <- gsub('cassandra_gobin', 'cassandra_godin', etudiants$prenom_nom)
etudiants$nom <- gsub('gobin', 'godin', etudiants$nom)
etudiants$prenom_nom <- gsub('louis_philipe_raymond', 'louis-philippe_raymond', etudiants$prenom_nom)
etudiants$prenom <- gsub('louis_philippe', 'louis-philippe', etudiants$prenom)
etudiants$prenom_nom <- gsub('audrey_ann_jobin', 'audrey-ann_jobin', etudiants$prenom_nom)
etudiants$prenom <- gsub('audrey_ann', 'audrey-ann', etudiants$prenom)
etudiants$prenom_nom <- gsub('jonathan_rondeau_leclaire', 'jonathan_rondeau-leclaire', etudiants$prenom_nom)
etudiants$nom <- gsub('rondeau_leclaire', 'rondeau-leclaire', etudiants$nom)
etudiants$region_administrative <- gsub('monterigie', 'monteregie', etudiants$region_administrative)
etudiants$prenom_nom <- gsub('arianne_barette', 'ariane_barrette', etudiants$prenom_nom)
etudiants$nom <- gsub('barette', 'barrette', etudiants$nom)
etudiants$prenom <- gsub('arianne', 'ariane', etudiants$prenom)
etudiants$prenom_nom <- gsub('samule_fortin', 'samuel_fortin', etudiants$prenom_nom)
etudiants$prenom_nom <- gsub('amelie_harbeck_bastien', 'amelie_harbeck-bastien', etudiants$prenom_nom)
etudiants$nom <- gsub('harbeck_bastien', 'harbeck-bastien', etudiants$nom)
etudiants$prenom_nom <- gsub('francis_bolly', 'francis_boily', etudiants$prenom_nom)
etudiants$nom <- gsub('bolly', 'boily', etudiants$nom)
etudiants$prenom_nom <- gsub('marie_burghin', 'marie_bughin', etudiants$prenom_nom)
etudiants$nom <- gsub('burghin', 'bughin', etudiants$nom)
etudiants$nom <- gsub('therrien', 'theriault', etudiants$nom)
etudiants$prenom_nom <- gsub('amelie_harbeck bastien', 'amelie_harbeck-bastien', etudiants$prenom_nom)
etudiants$prenom_nom <- gsub('sara-jade_lamontagne', 'sara_jade_lamontagne', etudiants$prenom_nom)
etudiants$prenom <- gsub('sara-jade', 'sara_jade', etudiants$prenom)
etudiants$nom <- gsub('guilemette', 'guillemette', etudiants$nom)
etudiants$nom <- gsub('ramond', 'raymond', etudiants$nom)
etudiants$prenom_nom <- gsub('ihuoma_elsie-ebere', 'ihuoma_elsie_ebere', etudiants$prenom_nom)
etudiants$nom <- gsub('elsie-ebere', 'elsie_ebere', etudiants$nom)
etudiants$prenom_nom <- gsub('edouard_nadon-baumier', 'edouard_nadon-beaumier', etudiants$prenom_nom)
etudiants$nom <- gsub('nadon-baumier', 'nadon-beaumier', etudiants$nom)
etudiants$prenom_nom <- gsub('sabrina_leclercqq', 'edouard_nadon-beaumier', etudiants$prenom_nom)
etudiants$nom <- gsub('leclercqq', 'leclercq', etudiants$nom)
etudiants[51,7][etudiants[51,7]=='E2021'] <- "A2021"
etudiants[38,5][etudiants[38,5]=='TRUE'] <- "FALSE"
etudiants$regime_coop <- gsub('VRAI', 'TRUE', etudiants$regime_coop)
etudiants$regime_coop <- gsub('FAUX', 'FALSE', etudiants$regime_coop)
etudiants[etudiants==""] <- NA #rajouter des NA dans les cases vides

###SYMBOLES
installed.packages('tidyverse')
library(tidyverse)
for(col in names(etudiants)){
  etudiants[,col] <- str_replace_all(etudiants[,col],pattern="\\s",replacement="")
  etudiants[,col] <- str_replace_all(etudiants[,col],pattern="<a0>",replacement="")
  etudiants[,col] <- str_replace_all(etudiants[,col],pattern="�",replacement="")
  etudiants[,col] <- str_replace_all(etudiants[,col],pattern="???",replacement="")
}

####ENLEVER DOUBLONS
etudiants_sans_doublons <- data.frame(colnames(etudiants))
for(i in 1:nrow(etudiants)){
if (etudiants[i,1] <-etudiants_sans_doublons[1:nrow(etudiants_sans_doublons),1]){
  }
  else(etudiants_sans_doublons[1:nrow(etudiants_sans_doublons,1)]<-etudiants[i,1]){
  }
}

  #CORRECTION DE LA TABLE DE COURS
cours$optionnel <- gsub('VRAI', 'TRUE', cours$optionnel)
cours$optionnel <- gsub('FAUX', 'FALSE', cours$optionnel)
cours[69,3][cours[69,3]=='2'] <- "1"   #changer la ligne 178 pour 1 credit
cours[40,3][cours[40,3]=='1'] <- "2"   #changer la ligne 40 pour 2 credits

cours_ob <- c("BCL102","BCM104","BCM113","BCM115","BIO104","BIO108","BIO109"
,"BIO300","BIO402","BIO500","BOT106","BOT400","BOT512","ECL110","ECL307","ECL308"
,"ECL403","ECL404","ECL510","ECL515","ECL516","ECL527","ECL604","ECL610"
,"ECL611","ECL615","GNT302","MCB100","MCB101","PSL105","TSB302","ZOO105"
,"ZOO106","ZOO306","ZOO307")

liste_cours <- cours[,1]
cours_opt <-liste_cours[!liste_cours %in% cours_ob]
for(i in 0:nrow(cours)){
 if(i %in% cours_ob){
   cours[i,2]=="FALSE"
  }
}
for(i in 0:nrow(cours)){
  if(i %in% cours_opt){
    cours[i,2]=="TRUE"
  }
}

##Correction de la table collaboration (générateur d'erreurs##
ref_nom <- etudiants$prenom_nom
nom_ver <- collaboration$etudiant1
correction <-sapply(nom_ver, function(x) x %in% ref_nom)
noms_incorrects <- nom_ver[which(!correction)]
print(noms_incorrects)
print(correction)
##correction tableau collaboration par DB
collaboration$etudiant1 <- gsub('yannick_sageau', 'yanick_sageau', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('savier_samson', 'xavier_samson', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('philippe_leonard-dufour', 'philippe_leonard_dufour', collaboration$etudiant1)
nouvelleligne <- c( 'eloise_bernier', 'eloise', 'bernier', NA,NA,NA,NA,NA)
etudiants <- rbind(etudiants,nouvelleligne)
collaboration$etudiant1 <- gsub('peneloppe_robert', 'penelope_robert', collaboration$etudiant1)
nouvelleligne1 <- c( 'naomie_morin', 'naomie', 'morin', NA,NA,NA,NA,NA)
etudiants <- rbind(etudiants,nouvelleligne1)
nouvelleligne2 <- c( 'karim_hamzaoui', 'karim', 'hamzaoui', NA,NA,NA,NA,NA)
etudiants <- rbind(etudiants,nouvelleligne2)
collaboration$etudiant1 <- gsub('louis-phillippe_theriault', 'louis-philippe_theriault', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('phillippe_bourassa', 'philippe_bourassa', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('justine_lebelle', 'justine_labelle', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('frederick_laberge', 'frederic_laberge', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('marie_christine_arseneau', 'marie-christine_arseneau', collaboration$etudiant1)
nouvelleligne3 <- c( 'gabrielle_moreault', 'gabrielle', 'moreault', NA,NA,NA,NA,NA)
etudiants <- rbind(etudiants,nouvelleligne3)
collaboration$etudiant1 <- gsub('catherine_viel_lapointe', 'catherine_viel-lapointe', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('laurie_anne_cournoyer', 'laurie-anne_cournoyer', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('margerite_duchesne', 'marguerite_duchesne', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('eve\xa0_dandonneau', 'eve_dandonneau', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('juliette_meilleur\xa0', 'juliette_meilleur', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('mia_carriere\xa0', 'mia_carriere', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('mael_guerin', 'mael_gerin', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('catherine_viel_lapointe', 'catherine_viel-lapointe', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('cassandra_gobin', 'cassandra_godin', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('louis_philippe_raymond', 'louis-philippe_raymond', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('audrey_ann_jobin', 'audrey-ann_jobin', collaboration$etudiant1)
nouvelleligne4 <- c( 'maxence_comyn', 'maxence', 'comyn', NA,NA,NA,NA,NA)
etudiants <- rbind(etudiants,nouvelleligne4)
collaboration$etudiant1 <- gsub('raphael_charlesbois', 'raphael_charlebois', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('jonathan_rondeau_leclaire', 'jonathan_rondeau-leclaire', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('francis_bourrassa', 'francis_bourassa', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('noemie_perrier-mallette', 'noemie_perrier-malette', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('francis_bolly', 'francis_boily', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('amelie_harbeck_bastien', 'amelie_harbeck-bastien', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('marie_burghin', 'marie_bughin', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('arianne_barette', 'ariane_barrette', collaboration$etudiant1)
nouvelleligne5 <- c( 'maude_viens', 'maude', 'viens', NA,NA,NA,NA,NA)
etudiants <- rbind(etudiants,nouvelleligne5)
collaboration$etudiant1 <- gsub('sabrica_leclercq', 'sabrina_leclercq', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('yanick_sagneau', 'yanick_sageau', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('sara_jade_lamontagne', 'sara-jade_lamontagne', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('philippe_leonard_dufour', 'philippe_leonard-dufour', collaboration$etudiant1)
collaboration$etudiant1 <- gsub('philippe_bourrassa', 'philippe_bourassa', collaboration$etudiant1)

##changement dans etudiants par DB
etudiants$prenom_nom <- gsub('sabrina_leclercqq', 'sabrina_leclercq', etudiants$prenom_nom)
etudiants$nom <- gsub('leclercqq', 'leclercq', etudiants$nom)
etudiants$prenom_nom <- gsub('sara_jade_lamontagne', 'sara-jade_lamontagne', etudiants$prenom_nom)
etudiants$prenom <- gsub('sara_jade', 'sara-jade', etudiants$prenom)
etudiants$prenom_nom <- gsub('sara-jade_lamontagne"', 'sara-jade_lamontagne', etudiants$prenom_nom)
etudiants$prenom <- gsub('lamontagne', 'sara-jade', etudiants$prenom)
etudiants$prenom <- gsub('pion', 'sarah', etudiants$prenom)
etudiants$prenom <- gsub('bovin', 'sarah-maude', etudiants$prenom)

