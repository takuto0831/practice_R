# install.packages("BNSL")
# https://www.slideshare.net/prof-joe/cran-r-bnsl
library(BNSL)
df <- alarm
mm <- mi_matrix(df)
edge_list <- kruskal(mm)
g <- graph_from_edgelist(edge_list,directed = FALSE)
V(g)$label <- colnames(df)
plot(g,vertex.size=20)
