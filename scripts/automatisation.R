getwd()
#setwd("C:\\Users\\phili\\Dropbox\\My PC (LAPTOP-1NC1A28D)\\Desktop\\donnees_BIO500\\projet_bio_500")

#git remote add(https://econumuds.github.io/BIO500)

data = read.table("exemple_targets/data/data.txt", header = T)

resultat_modele = function(data) lm(data$Y~data$X)

ma_figure = function(data, resultat_modele) {
  plot(data$X, data$Y, xlab = "X", ylab = "Y", 
       cex.axis = 1.5, cex.lab = 1.5, pch = 19)
  abline(resultat_modele)
}


# _targets.R file
library(targets)
source("exemple_targets/R/analyse.R")
source("exemple_targets/R/figure.R")
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

source("exemple_targets/_targets.R")
tar_glimpse()
tar_make()
ar_visnetwork()
