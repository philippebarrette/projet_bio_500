rsqliteVersion()
con <- dbConnect(SQLite(), dbname="data_directory")
tables <- dbListTables(con)
print(tables)
#for (table in tables) {
#  dbSendQuery(con, paste0("DROP TABLE IF EXISTS ", table))
#}
bd_collaborations  <-read.csv(file=name_tbl_collaborations)
bd_etudiants  <-read.csv(file=name_tbl_etudiants)
bd_cours  <-read.csv(file=name_tbl_cours)

SQL_tbl_cours <- dbWriteTable(con, append = TRUE, name = "cours", value = bd_cours, row.names = FALSE)
SQL_tbl_etudiants <-dbWriteTable(con, append = TRUE, name = "etudiants", value = bd_etudiants, row.names = FALSE)
SQL_tbl_collaborations <-dbWriteTable(con, append = TRUE, name = "collaborations", value = bd_collaborations, row.names = FALSE)

tbl_cours <- "
CREATE TABLE cours(
  sigle         VARCHAR(6),
  optionnel     VARCHAR(5),
  credits       VARCHAR(1),
  PRIMARY KEY (cours));"
dbSendQuery(con, tbl_cours)

tbl_etudiants <- "
CREATE TABLE ETUDIANTS(
  prenom_nom                  VARCHAR(50),
  prenom                      VARCHAR(40),
  nom                          VARCHAR(200),
  region_adminisatrative       VARCHAR(40),
  regime_coop                   BOLEAN,
  formation_prealable           VARCHAR(40),
  annee_debut                   VARCHAR(5),
  programme                     INTEGER,
  PRIMARY KEY (prenom_nom));"
dbSendQuery(con, tbl_etudiants)

tbl_collaborations <- "
CREATE TABLE collaborations(
  etudiant1      VARCHAR(50),
  etudiant2      VARCHAR(40),
  sigle        VARCHAR(6),
  PRIMARY KEY (etudiant1,etudiant2));"
dbSendQuery(con, tbl_collaborations)

## REQUETE qui donne le nombre de collaborations pour chaque étudiant
nb_lien_etudiants <- "
SELECT etudiant1,COUNT(*) AS nb_lien_par_etudiants
FROM collaborations
GROUP BY etudiant1
ORDER BY nb_lien_par_etudiants;"
nombre_liens_etudiants <- dbGetQuery(con, nb_lien_etudiants)
head(nombre_liens_etudiants)

## REQUETE qui donne le nombre de collaborations par cours
nb_collab_cours <- "
SELECT sigle,COUNT(*) AS nombre_collaboration_cours
FROM collaborations
GROUP BY sigle
ORDER BY nombre_collaboration_cours;"
nombre_collab_cours <- dbGetQuery(con, nb_collab_cours)
head(nombre_collab_cours)

