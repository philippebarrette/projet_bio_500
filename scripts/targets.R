render("mon_rmarkdown.Rmd")
rmarkdown::render
print(utils::getSrcDirectory(function(){}))
print(utils::getSrcFilename(function(){}, full.names = TRUE))
directory <- setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(targets)
source("figure.R")
source("requetes_sql.R")
tar_option_set(packages = c("MASS", "igraph"))
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
