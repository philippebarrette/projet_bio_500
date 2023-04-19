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
        resultat_collaboration_matrice[k, i] <- resultat_collaboration_matrice[k, i] + 1
      }
     
      if (etudiants_unique[i] == collaboration[j,2]){
        for (k in 1:n_personnes){
          if (collaboration[j,1] == etudiants_unique[k]){
            break
          }
        }
        resultat_collaboration_matrice[i, k] <- resultat_collaboration_matrice[i, k] + 1
        resultat_collaboration_matrice[k, i] <- resultat_collaboration_matrice[k, i] + 1 
      }
    }
    if (sum(is.na(resultat_collaboration_matrice)) > 0) {
    warning("NA values found in the collaboration matrix.")
    }
  }
  return(resultat_collaboration_matrice)
}
adj_matrice <-compter_collaborations_matrice(collaboration)
#rm(resultat_collaboration_matrice)

## FIGURE DU RESEAU DE COLLABORATION
g <- graph.adjacency(adj_matrice, mode = "undirected")
deg <- degree(g)
rk <- rank(deg)
min_size <- 5
size.vec <- rep(1, vcount(g))  # set initial size of all nodes to 1
size.vec <- size.vec / max(size.vec) * 10
size.vec <- scale(size.vec, center = FALSE) * 10
col.vec <- hsv(seq(0, 1, length.out=length(rk)), 0.8, 0.8)[rk]
# set color attribute for each vertex based on its rank
for (i in 1:vcount(g)) {
  V(g)$color[i] <- col.vec[i]
}
V(g)$size <- size.vec
E(g)$weight <- 1 / (deg^2)
layout <- layout_with_kk(g, weights = E(g)$weight, maxiter = 1000)
tryCatch({
  plot(g, layout=layout, vertex.label=NA, vertex.frame.color=NA, 
       vertex.color = V(g)$color, vertex.size = V(g)$size, 
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
eigen_centrality(g)$vector