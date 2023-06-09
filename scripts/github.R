# Installer le package usethis
install.packages("usethis")
## Enregistrer les informations de l'utilisateur :
usethis::use_git_config(user.name = "philippebarrette", user.email = "philippe.rettebar@gmail.com")
## Cr�er un jeton d'acc�s :
usethis::create_github_token() 
### D�finir la date d'expiration comme "Aucune expiration"
### Copier le jeton d'acc�s dans le presse-papier
## Enregistrer le jeton d'acc�s :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
credentials::set_github_pat()
gitcreds::gitcreds_set()
## Red�marrer R !!!


usethis::git_sitrep()
## Votre nom d'utilisateur et e-mail devraient �tre 
## correctement retourn�s.
## Aussi, le rapport devrait contenir quelque chose comme ceci :
## 'Personal access token: '<found in env var>''
## Si un message d'erreur persiste, v�rifier que le fichier .Renviron est bien configur� :
## Appeler `usethis::edit_r_environ()` pour mettre � jour le fichier manuellem


# _targets.R file

# D�pendances
library(targets)
tar_option_set(packages = c("MASS", "igraph"))

# Scripts R
source("R/analyse.R")
source("R/figure.R")

# Pipeline
list(
  # Une target pour le chemin du fichier de donn�e permet de suivre les 
  # changements dans le fichier
  tar_target(
    name = path, # Cible
    command = "data/data.txt", # Emplacement du fichier
    format = "file"
  ), 
  # La target suivante a "path" pour d�pendance et importe les donn�es. Sans
  # la s�paration de ces deux �tapes, la d�pendance serait bris�e et une
  # modification des donn�es n'entrainerait pas l'ex�cution du pipeline
  tar_target(
    name = data, # Cible pour l'objet de donn�es
    command = read.table(path) # Lecture des donn�es
  ),   
  tar_target(
    resultat_modele, # Cible pour le mod�le 
    mon_modele(data) # Ex�cution de l'analyse
  ),
  tar_target(
    figure, # Cible pour l'ex�cution de la figure
    ma_figure(data, resultat_modele) # R�alisation de la figure
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
    resultat_modele, # Cible pour le mod�le 
    mon_modele(data) # Ex�cution de l'analyse
  ),
  tar_target(
    figure, # Cible pour l'ex�cution de la figure
    ma_figure(data, resultat_modele) # R�alisation de la figure
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
