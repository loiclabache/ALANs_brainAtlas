################################################################################
# Written by Loïc Labache, Ph.D.                                               #
# Holmes Lab, Department of Psychiatry - Rutgers University                    #
# January 26, 2024                                                             #
################################################################################

# Packages......................................................................
#...............................................................................
packages <- c("here", "psych", "NbClust", "igraph", "qgraph")
lapply(packages, require, character.only = T)

# Load Data.....................................................................
#...............................................................................
path_data = "Data"
rs_data = readRDS(here(path_data, "130_participants_BOLD_rs_BILGIN.Rds"))

# Classification................................................................
#...............................................................................
for (i in 1:dim(rs_data)[1]){
  rs_data[i,,] = fisherz(rs_data[i,,])
}
rs_data_avg = fisherz2r(colMeans(rs_data))
# "NbClust" criteria, to select number of clusters:
nom_methode =  c("kl", "ch", "hartigan", "cindex", "db", "silhouette",
                 "ratkowsky", "ball", "ptbiserial", "gap", "frey", "mcclain",
                 "gamma", "gplus", "dunn", "sdindex", "sdbw")
nbPartition = rep(NaN, length(nom_methode))
for (i in 1:length(nom_methode)){
  nbPartition[i] = NbClust(rs_data_avg, 
                           diss = as.dist(((1-rs_data_avg)/2),
                                          diag = FALSE),
                           distance = NULL,
                           min.nc = 4,
                           method="ward.D2",
                           index = nom_methode[i])$Best.nc[1]
  print(paste("Number of Clusters: ", nbPartition[i]," (criteria: ", 
              nom_methode[i], ")", sep=""))
}
nb_cluster_table = table(nbPartition)
nb_cluster = as.integer(names(nb_cluster_table[which.max(nb_cluster_table)]))
# Clustering:
h = hclust(as.dist(((1-rs_data_avg)/2),
                   diag = FALSE),
           method = "ward.D2")
set.seed(13)
restingStateNetwork = cutree(h, nb_cluster)

# Graph Theory Metrics..........................................................
#...............................................................................
pos_rs_data = rs_data
for (i in 1:dim(pos_rs_data)[1]){
  tmp = pos_rs_data[i,,]
  tmp[tmp < 0] = 0
  pos_rs_data[i,,] = fisherz2r(tmp)
}
res_DC = array(NaN, dim=c(dim(pos_rs_data)[1],
                          dim(pos_rs_data)[2]))
res_BC = res_DC
colnames(res_DC) = colnames(res_BC) = dimnames(pos_rs_data)[[2]]
rownames(res_DC) = rownames(res_BC) = dimnames(pos_rs_data)[[1]]
for (i in 1:length(table(restingStateNetwork))){
  for (k in 1:dim(pos_rs_data)[1]){
    print(paste("Network ; ", i, "/", length(table(restingStateNetwork)),
                ". Participant ; ", k, "/", dim(pos_rs_data)[1], sep=""))
    gI = graph_from_adjacency_matrix(pos_rs_data[k,,][restingStateNetwork == i,
                                                      restingStateNetwork == i],
                                     weighted=TRUE,
                                     mode="undirected", 
                                     diag=FALSE)
    dc_N = strength(gI)
    bc_N = setNames(centrality_auto(gI, weighted = TRUE, 
                                    signed=FALSE)$node.centrality$Betweenness, 
                    names(V(gI)))
    res_DC[k, ][restingStateNetwork == i] = dc_N
    res_BC[k, ][restingStateNetwork == i] = bc_N
  }
}

# "res_DC" is a matrix that contains the degree centrality, or strength,
# of each region for each individual.
# "res_BC" is a matrix that contains the betweenness centrality, or sunexity,
# of each region for each individual.