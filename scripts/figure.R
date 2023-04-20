#MATRICE DES INTERACTIONS ENTRE LES ETUDIANTS
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
E(g)$weight <- rep(1, ecount(g)) / (deg^2)
layout <- layout_with_fr(g,area = vcount(g))
Reseau_de_collaboration<- tryCatch({
  plot(g, layout=layout, vertex.label=NA, vertex.frame.color=NA, 
       vertex.color = V(g)$color, vertex.size = size.vec, 
       arrow.mode = 1, edge.arrow.size=0.5)
}, error = function(e) {
  cat("Error in plot:", conditionMessage(e), "\n")
  if (exists("vr")) {
    cat("Vertices causing the error:", which(is.na(vr)), "\n")
  }
})

# Évalue la présence communautés dans le graphe
wtc = walktrap.community(g)
# Calcule la modularité à partir des communautés
modularity(wtc)
distances(g)
eigen_centrality<- eigen_centrality(g)$vector

## HISTOGRAMME DU NOMBRE DE COLLAB POUR CHAQUE ETUDIANT
rk_hist<-rank(nombre_liens_etudiants)
h<-hist(nombre_liens_etudiants$nb_lien_par_etudiants,breaks = seq(from=0,
to=600, by=50), col="white", border="black", lwd=2, main = "Histogramme des liens de collaboration",
xlim = c(0, 600), xlab = "Nombre de collaboration",
ylab = "Nombre d'étudiants")
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

## HISTOGRAMME DU NB DE COLLAB POUR CHAQUE COURS
rk_hist<-rank(nombre_collab_cours)
h2<-hist(nombre_collab_cours$nombre_collaboration_cours,breaks = seq(from=0,
to=6000, by=300), col="white", border="black", lwd=2, main = "Histogramme du nombre de collaborations par cours",
xlim = c(0, 6000), xlab = "Nombre de collaboration par cours",
ylab = "Nombre d'étudiants")
cols2 <- c("#EFEFEF", "#DEDEDE", "#CECECE", "#BEBEBE", "#AEAEAE", "#9E9E9E",
          "#8E8E8E", "#7E7E7E")
for (i in 1:length(h2$counts)) {
  x <- c(h2$breaks[i], h2$breaks[i + 1], h2$breaks[i + 1], h2$breaks[i])
  y <- c(0, 0, h2$counts[i], h2$counts[i])
  polygon(x, y, col = cols2[i], border = "black", lwd = 2)
}
figure_directory <- gsub("/scripts", "/figure/",directory)
reseau<-paste(figure_directory,"g",sep="")
collab1<-paste(figure_directory,"h",sep="")
collab2<-paste(figure_directory,"h2",sep="")

png(filename = "g.png", width = 800, height = 600, units = "px", res = 300)
plot(1:10,1:10)
dev.off()

png(filename = "h.png", width = 800, height = 600, units = "px", res = 300)
png(filename = "h2.png", width = 800, height = 600, units = "px", res = 300)



