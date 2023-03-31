getwd()
setwd("C:/Users/phili/Documents")
install.packages('RSQLite')
library(RSQLite)

con <- dbConnect(SQLite(), dbname="C:/Users/phili/Documents")
dbSendQuery(con,"Instructions SQL à envoyer;")

CREATE TABLE auteurs (
  auteur      VARCHAR(50),
  statut      VARCHAR(40),
  institution VARCHAR(200),
  ville       VARCHAR(40),
  pays        VARCHAR(40),
  PRIMARY KEY (auteur)
);