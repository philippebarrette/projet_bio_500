#FONCTIONS POUR LE TARGET

f_connect <- function (){
  con <- dbConnect(SQLite(), dbname="data_directory")
}

f_creation_table <- function(con,tab_collaboration,tab_cours,tab_etudiants){
con <- dbConnect(SQLite(), dbname="data_directory")

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

SQL_tbl_cours <- dbWriteTable(con, append = TRUE, name = "cours", value = bd_cours, row.names = FALSE)
SQL_tbl_etudiants <-dbWriteTable(con, append = TRUE, name = "etudiants", value = bd_etudiants, row.names = FALSE)
SQL_tbl_collaborations <-dbWriteTable(con, append = TRUE, name = "collaborations", value = bd_collaborations, row.names = FALSE)
}

#hist collab
f_requete1 <- function (){
con <- dbConnect(SQLite(), dbname="data_directory")
  nb_lien_etudiants <- "
SELECT etudiant, COUNT(*) AS nb_lien_par_etudiants
FROM (
    SELECT etudiant1 AS etudiant
    FROM collaborations
    UNION ALL
    SELECT etudiant2 AS etudiant
    FROM collaborations
) AS temp
GROUP BY etudiant
ORDER BY nb_lien_par_etudiants DESC;"
  nombre_liens_etudiants <- dbGetQuery(con, nb_lien_etudiants)
}

#hist cours
f_requete2 <- function (){
con <- dbConnect(SQLite(), dbname="data_directory")
  nb_collab_cours <- "
SELECT sigle,COUNT(*) AS nombre_collaboration_cours
FROM collaborations
GROUP BY sigle
ORDER BY nombre_collaboration_cours;"
  nombre_collab_cours <- dbGetQuery(con, nb_collab_cours)
}

#création hist 1
f_hist_collab <- function (requete_hist1){
png(filename = paste0(figure_directory,"/Histogramme_de_collaboration_entre_etudiants.png", sep=""),width = 2000, height = 2000, units = "px", res = 300)
rk_hist<-rank(nombre_liens_etudiants)
h<-hist(nombre_liens_etudiants$nb_lien_par_etudiants,breaks = seq(from=0,
to=200, by=20), col="white", border="black", lwd=2, main = "Histogramme des liens de collaboration",
  xlim = c(0, 200), xlab = "Nombre de collaboration",ylim=c(0,180),ylab = "Nombre d'étudiants")
#rank_counts<-table(rk_hist)
#for (i in unique(rk_hist)) {
# text(i, rank_counts[i], labels=i, pos=3)
#}
cols <- c("#EFEFEF", "#DEDEDE", "#CECECE", "#BEBEBE", "#AEAEAE", "#9E9E9E",
          "#8E8E8E", "#7E7E7E", "#6E6E6E", "#5E5E5E")
for (i in 1:length(h$counts)) {
  x <- c(h$breaks[i], h$breaks[i + 1], h$breaks[i + 1], h$breaks[i])
  y <- c(0, 0, h$counts[i], h$counts[i])
  polygon(x, y, col = cols[i], border = "black", lwd = 2)
  } 
}

#création hist 2
f_hist_cours <- function (requete_hist2){
png(filename = paste0(figure_directory,"/Histogramme_de_collaboration_par_cours.png", sep=""),width = 2000, height = 3000, units = "px", res = 300)
nombre_collab_cours$sigle <- factor(nombre_collab_cours$sigle,levels = nombre_collab_cours$sigle[order(nombre_collab_cours$nombre_collaboration_cours)])
 hist <- ggplot(nombre_collab_cours, aes(x = nombre_collaboration_cours, y = sigle)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    xlab("Nombre de collaborations") +
    ylab("Sigle") +
    ggtitle("Histogramme du nombre de collaborations par cours") +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(axis.text.y = element_text(margin = margin(r = 10)))+
    geom_text(aes(label = nombre_collaboration_cours), hjust = -0.2, size = 2)
}

#creation figure reseau de collab
f_reseau <- function (){
  compter_collaborations_matrice <- function(collaboration) {
    etudiants_unique = unique((c(collaboration[,1],collaboration[,2])))
    n_personnes <- length(etudiants_unique)
    resultat_collaboration_matrice <- matrix(0, nrow = n_personnes, ncol = n_personnes,
                                             dimnames = list(etudiants_unique, etudiants_unique))
    for (i in 1:n_personnes){
      print(etudiants_unique[i])
      for (j in 1:nrow(collaboration)) {
        #print(collaboration[j,1:10])
        #print(collaboration[j,2:10])
        if (etudiants_unique[i] == collaboration[j,1]){
          for (k in 1:n_personnes){
            if (collaboration[j,2] == etudiants_unique[k]){
              break
            }
          }
          resultat_collaboration_matrice[i, k] <- resultat_collaboration_matrice[i, k] + 1
        }
        
        if (etudiants_unique[i] == collaboration[j,2]){
          for (k in 1:n_personnes){
            if (collaboration[j,1] == etudiants_unique[k]){
              break
            }
          }
          resultat_collaboration_matrice[i, k] <- resultat_collaboration_matrice[i, k] + 1
        }
      }
      if (sum(is.na(resultat_collaboration_matrice)) > 0) {
        warning("NA values found in the collaboration matrix.")
      }
    }
    return(resultat_collaboration_matrice)
    print(unique(diag(adj_matrice)))
  }
  adj_matrice <-compter_collaborations_matrice(collaboration)
  #rm(resultat_collaboration_matrice)
  
  ## FIGURE DU RESEAU DE COLLABORATION
  png(filename = paste0(figure_directory,"/Reseau_de_collaboration.png",
                        sep=""), width = 8000, height = 8000, units = "px", res = 300)
  g <- graph.adjacency(adj_matrice, mode = "undirected")
  rk <- rank(deg)
  deg <- degree(g)
  min_size <- 5
  size.vec <- deg / max(deg) * 15
  threshold <- 3
  size.vec[size.vec < threshold] <- size.vec[size.vec < threshold] * 8
  col.vec <- hsv(seq(0, 1, length.out=length(rk)), 0.8, 0.8)[rk]
  # set color attribute for each vertex based on its rank
  for (i in 1:vcount(g)) {
    V(g)$color[i] <- col.vec[i]
    print(sprintf("Vertex %d, rank %s, color %s", i, rk[i], col.vec[i]))
  }
  E(g)$weight <-  rep(1, ecount(g))/100000*deg^0.01
  #E(g)$weight <- rep(1, ecount(g)) / (deg^2)
  layout <- layout_with_fr(g, weights=E(g)$weight, area=vcount(g)^2,niter=5000)
  Reseau_de_collaboration<- tryCatch({
    plot(g, layout=layout, vertex.label=NA, vertex.frame.color=NA, 
         vertex.color = V(g)$color, vertex.size = size.vec, 
         arrow.mode = 1, edge.arrow.size=0.5,
         xlim=c(-1,1), ylim=c(-1,1))
  }, error = function(e) {
    cat("Error in plot:", conditionMessage(e), "\n")
    if (exists("vr")) {
      cat("Vertices causing the error:", which(is.na(vr)), "\n")
    }
  })
  
}


