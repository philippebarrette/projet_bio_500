render("rapport.Rmd")
rmarkdown::render
#Faire runer cette partie en premier
print(utils::getSrcDirectory(function(){}))
print(utils::getSrcFilename(function(){}, full.names = TRUE))
directory <- setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(targets)
install.packages('tarchetypes')
library(tarchetypes)  # Utile pour render le rapport (tar_render)

source("nettoyage_donnees.r")
source("figure.R")
source("requetes_sql.R")
source("fonctions_target.R")


tar_option_set(packages = c("RSQLite", "tidyverse","MASS", "igraph", "rmarkdown",
                            "ggplot2", "rticles","igraph","RColorBrewer","viridis"))
list(
#Lecture des données
  tar_target(tab_collaboration,read.csv("datatbl_collaborations.csv", sep=";")),
  tar_target(tab_cours,read.csv("datatbl_cours.csv", sep=";")),
  tar_target(tab_etudiants,read.csv("datatbl_etudiants.csv", sep=";")),
#Connection à SQL
  tar_target(con,f_connect()),
#Création des tables SQL
  tar_target(tables,f_creation_table(con,tab_collaboration,tab_cours,tab_etudiants)),
#Requête SQL hist collab
  tar_target(requete_hist1,f_requete1() ),
#Création hist collab
  tar_target(hist_collab,f_hist_collab(requete_hist1)),
#Requête SQL hist cours
  tar_target(requete_hist2,f_requete2()),   
#Création hist cours
  tar_target(hist_cours,f_hist_cours(requete_hist2)),
#Création figure réseau de collab
  tar_target(fig_reseau,f_reseau())
)

#Creation Markdown
  tar_render(rapport,"rapport.Rmd")


source("targets.R")
tar_glimpse()
tar_make()
tar_visnetwork()
