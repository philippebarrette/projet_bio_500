# Installer le package usethis
install.packages("usethis")
## Enregistrer les informations de l'utilisateur :
usethis::use_git_config(user.name = "philippebarrette", user.email = "philippe.rettebar@gmail.com")
## Créer un jeton d'accès :
usethis::create_github_token() 
### Définir la date d'expiration comme "Aucune expiration"
### Copier le jeton d'accès dans le presse-papier
## Enregistrer le jeton d'accès :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
credentials::set_github_pat()
gitcreds::gitcreds_set()
## Redémarrer R !!!


usethis::git_sitrep()
## Votre nom d'utilisateur et e-mail devraient être 
## correctement retournés.
## Aussi, le rapport devrait contenir quelque chose comme ceci :
## 'Personal access token: '<found in env var>''
## Si un message d'erreur persiste, vérifier que le fichier .Renviron est bien configuré :
## Appeler `usethis::edit_r_environ()` pour mettre à jour le fichier manuellem


# _targets.R file

# Dépendances
library(targets)
tar_option_set(packages = c("MASS", "igraph"))

# Scripts R
source("R/analyse.R")
source("R/figure.R")

# Pipeline
list(
  # Une target pour le chemin du fichier de donnée permet de suivre les 
  # changements dans le fichier
  tar_target(
    name = path, # Cible
    command = "data/data.txt", # Emplacement du fichier
    format = "file"
  ), 
  # La target suivante a "path" pour dépendance et importe les données. Sans
  # la séparation de ces deux étapes, la dépendance serait brisée et une
  # modification des données n'entrainerait pas l'exécution du pipeline
  tar_target(
    name = data, # Cible pour l'objet de données
    command = read.table(path) # Lecture des données
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


# _targets.R file, RNORM
library(targets)
#source("exemple_targets/R/analyse.R")
#source("exemple_targets/R/figure.R")
tar_option_set(packages = c("MASS", "igraph"))
make_data = function() rnorm(1000,1,1)
make_histo =function(data) hist(data)
list(
  tar_target(
    data, # Le nom de l'objet
    read.table("exemple_targets/R/data.txt", header = T) # Lecture du fichier
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



data = read.table("exemple_targets/data/data.txt", header = T)
resultat_modele = function(data) lm(data$Y~data$X)
ma_figure = function(data, resultat_modele) {
  plot(data$X, data$Y, xlab = "X", ylab = "Y", 
       cex.axis = 1.5, cex.lab = 1.5, pch = 19)
  abline(resultat_modele)
}


tar_glimpse()
tar_make()
tar_visnetwork()

render("mon_rmarkdown.Rmd")
tar_render()
