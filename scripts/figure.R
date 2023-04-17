#MATRICE DES INTERACTIONS ENTRE LES ETUDIANTS
collaboration <- na.omit(collaboration)
collaboration <- collaboration[complete.cases(collaboration),]
collaboration <- collaboration[collaboration$etudiant1 != "" & collaboration$etudiant2 != "", ]

compter_collaborations_matrice <- function(collaboration) {
  personnes <- etudiants_final[,1]
  n_personnes <- length(personnes)
  collaboration$etudiant1 <- as.integer(collaboration$etudiant1)
  collaboration$etudiant2 <- as.integer(collaboration$etudiant2)
    matrice_collaborations <- matrix(0, nrow = n_personnes, ncol = n_personnes,
                                   dimnames = list(personnes, personnes))
  for (i in seq_len(nrow(collaboration))) {
    personne1 <- collaboration$etudiant1[i]
    personne2 <- collaboration$etudiant2[i]
    matrice_collaborations[personne1, personne2] <- matrice_collaborations[personne1, personne2] + 1
    matrice_collaborations[personne2, personne1] <- matrice_collaborations[personne2, personne1] + 1
  }
    if (sum(is.na(matrice_collaborations)) > 0) {
    warning("NA values found in the collaboration matrix.")
  }
    return(matrice_collaborations)
}
resultat_collaboration_matrice <- compter_collaborations_matrice(collaboration)
print(resultat_collaboration_matrice)

## FIGURE DU RESEAU DE COLLABORATION
g <- graph.adjacency(resultat_collaboration_matrice, mode = "undirected")
deg <- degree(g)
rk <- rank(deg)
deg <- degree(g)
min_size <- 5
size.vec <- scale(size.vec, center = FALSE) * 10
col.vec <- hsv(seq(0, 1, length.out=length(rk)), 0.8, 0.8)[rk]
# set color attribute for each vertex based on its rank
for (i in 1:vcount(g)) {
  V(g)$color[i] <- col.vec[i]
}
V(g)$size <- 10  # fixed node size of 10
E(g)$weight <- 1/deg^2
layout <- layout_with_kk(g, weights = E(g)$weight)
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