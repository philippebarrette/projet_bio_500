#MATRICE DES INTERACTIONS ENTRE LES ETUDIANTS
etudiants_unique = unique((c(collaboration[,1],collaboration[,2])))

compter_collaborations_matrice <- function(collaboration) {
  etudiants_unique = unique((c(collaboration[,1],collaboration[,2])))
  n_personnes <- length(etudiants_unique)
  print(n_personnes)
  
  resultat_collaboration_matrice <- matrix(0, nrow = n_personnes, ncol = n_personnes,
                                   dimnames = list(etudiants_unique, etudiants_unique))
  for (i in 1:10) {
    for (j in nrow(etudiants_unique)){
      if(etudiants_unique[j] == collaboration[i,1]){
        personne1 <- j
        print(etudiants_unique[j],j)
      if(etudiants_unique[j] == collaboration[i,2]){
        personne2 <- j  
        print(etudiants_unique[j],j)
        
      }
    }
    resultat_collaboration_matrice[personne1, personne2] <- resultat_collaboration_matrice[personne1, personne2] + 1
    resultat_collaboration_matrice[personne2, personne1] <- resultat_collaboration_matrice[personne2, personne1] + 1
  }
  if (sum(is.na(resultat_collaboration_matrice)) > 0) {
    warning("NA values found in the collaboration matrix.")
  }
  return(resultat_collaboration_matrice)
  }
}
adj_matrice <-compter_collaborations_matrice(collaboration)

rm(resultat_collaboration_matrice)

# Create a data frame of unique student pairs with the number of collaborations
collab_count <- collaboration %>%
  group_by(etudiant1, etudiant2) %>%
  summarize(collab = n()) %>%
  ungroup()

# Create an empty matrix with row and column names
students <- unique(c(collab_count$etudiant1, collab_count$etudiant2))
collab_matrix <- matrix(0, nrow = length(students), ncol = length(students),
                        dimnames = list(students, students))

# Fill in the collaboration counts in the matrix
for (i in 1:nrow(collab_count)) {
  collab_matrix[collab_count[i, "etudiant1"], collab_count[i, "etudiant2"]] <- collab_count[i, "collab"]
  collab_matrix[collab_count[i, "etudiant2"], collab_count[i, "etudiant1"]] <- collab_count[i, "collab"]
}




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