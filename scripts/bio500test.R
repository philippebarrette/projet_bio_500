getwd()
setwd("C:/Users/phili/Dropbox/My PC (LAPTOP-1NC1A28D)/Desktop/bio500a")
install.packages('RSQLite')
library(RSQLite)
library(RSQLite, dependencies= TRUE)

con <- dbConnect(SQLite(), dbname="reseau.db")
dbSendQuery(con,"Instructions SQL à envoyer;")

#Lecture des fichiers CSV
bd_auteurs <- read.csv(file ="authors.csv")
bd_articles <- read.csv(file ="articles.csv")
bd_collab <- read.csv(file = "collaboration.csv")

# Injection des enregistrements dans la BD
dbWriteTable(con, append = TRUE, name = "auteurs", value = bd_auteurs, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "articles", value = bd_articles, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "collaborations", value = bd_collab, row.names = FALSE)

table_auteurs <-'
CREATE TABLE auteurs (
  auteur      VARCHAR(50),
  statut      VARCHAR(40),
  institution VARCHAR(200),
  ville       VARCHAR(40),
  pays        VARCHAR(40),
  PRIMARY KEY (auteur)
);'

table_collab <-'
CREATE TABLE collaborations (
  auteur1     VARCHAR(40),
  auteur2     VARCHAR(40),
  articleID   VARCHAR(20),
  PRIMARY KEY (auteur1, auteur2, articleID),
  FOREIGN KEY (auteur1) REFERENCES auteurs(auteur),
  FOREIGN KEY (auteur2) REFERENCES auteurs(auteur),
  FOREIGN KEY (articleID) REFERENCES articles(articleID)
);'

table_articles <-'
CREATE TABLE articles (
  articleID   VARCHAR(20) NOT NULL,
  titre       VARCHAR(200) NOT NULL,
  journal     VARCHAR(80),
  annee       DATE,
  citations   INTEGER CHECK(annee >= 0),
  PRIMARY KEY (articleID)
);'

dbSendQuery(con, table_collab)
dbListTables(con)

ALTER TABLE database_name.table_name RENAME TO new_table_name;
ALTER TABLE database_name.table_name ADD COLUMN column_def...;

dbSendQuery(con,"DROP TABLE auteurs;")
#DROP TABLE supprime l'ensemble de la table et ses données.

#dbDisconnect(con) permet de fermer la connection avec le
fichier de base de données (permet à un autre utilisateur
de se connecter)

sql_requete <- "
SELECT articleID, journal, annee
  FROM articles LIMIT 10
;"
articles <- dbGetQuery(con, sql_requete)
head(articles)
articles

sql_requete <- "
  SELECT auteur, statut, institution
  FROM auteurs
  WHERE institution LIKE 'Universite de Sherbrooke';"
auteurs <- dbGetQuery(con, sql_requete)
head(auteurs)
