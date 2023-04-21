render("mon_rmarkdown.Rmd")
rmarkdown::render
print(utils::getSrcDirectory(function(){}))
print(utils::getSrcFilename(function(){}, full.names = TRUE))
directory <- setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(targets)
install.packages('tarchetypes')
library(tarchetypes)  # Utile pour render le rapport (tar_render)

#Charger les fonctions à utiliser dans le target
source("scripts/nettoyage_donnees.r")
source("scripts/figure.R")
source("scripts/requetes_sql.R")

source("scripts/fonctions_target.R")


tar_option_set(packages = c("RSQLite", "tidyverse","MASS", "igraph", "rmarkdown"))
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
  tar_target(fig_reseau,f_reseau()),
#Creation Markdown
  tar_render(rapport,"rapport.Rmd")
)


#copier-coller du prof
list(  
  tar_target(
    data, # Le nom de l'objet
    read.table("data.txt", header = T) # Lecture du fichier
  ), 
  tar_target(
    resultat_modele, # Cible pour le modèle 
    mon_modele(data) # Exécution de l'analyse
  ),
  tar_target(
    figure, # Cible pour l'exécution de la figure
    ma_figure(data, resultat_modele) # Réalisation de la figure
  )
)

source("")
tar_glimpse()
tar_make()
tar_visnetwork()
