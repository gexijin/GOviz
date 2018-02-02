# This a program for ploting enrichment results by highlighting the similarities among terms
# must have columns: Direction, adj.Pval   Pathways Genes
#  Direction	adj.Pval	nGenes	Pathways		Genes
#Down regulated	3.58E-59	131	Ribonucleoprotein complex biogenesis	36	Nsun5 Nhp2 Rrp15 
#Down regulated	2.55E-57	135	NcRNA metabolic process	23	Nsun5 Nhp2 Rrp15 Emg1 Ddx56 Rsl1d1 enrichmentPlot <- function( enrichedTerms){
# Up or down regulation is color-coded
# gene set size if represented by the size of marker
# Steven Xijin Ge  @South Dakota State Univ  http://ge-lab.org/ 
enrichmentPlot <- function( enrichedTerms, rightMargin=33) {
  if(class(enrichedTerms) != "data.frame") return(NULL)
  library(dendextend) # customizing tree
  
  geneLists = lapply(enrichedTerms$Genes, function(x) unlist( strsplit(as.character(x)," " )   ) )
  names(geneLists)= enrichedTerms$Pathways
  n = length(geneLists)
  w <- matrix(NA, nrow = n, ncol = n)
# compute overlaps among all gene lists
    for (i in 1:n) {
        for (j in i:n) {
            u <- unlist(geneLists[i])
            v <- unlist(geneLists[j])
            w[i, j] = length(intersect(u, v))/length(unique(c(u,v)))
        }
    }
# the lower half of the matrix filled in based on symmetry
    for (i in 1:n) 
        for (j in 1:(i-1)) 
            w[i, j] = w[j,i] 
    
  Terms = paste( sprintf("%-1.0e",as.numeric(enrichedTerms$adj.Pval)), 
				names(geneLists))
  rownames(w) = Terms
  colnames(w) = Terms
  par(mar=c(0,0,2,rightMargin)) # a large margin for showing 

  dend <- as.dist(1-w) %>%
	hclust (method="average") 
  ix = dend$order # permutated order of leaves

  leafType= as.factor( enrichedTerms$Direction[ix] )
  if(length(unique(enrichedTerms$Direction)  ) ==2 )
	leafColors = c("green","red")  else  # mycolors
	leafColors = mycolors 
  #leafSize = unlist( lapply(geneLists,length) ) # leaf size represent number of genes
  #leafSize = sqrt( leafSize[ix] )  
  leafSize = -log10(enrichedTerms$adj.Pval[ix] ) # leaf size represent P values
  leafSize = 2*leafSize/max( leafSize ) + .3
  
  dend <- dend %>% 
	as.dendrogram(hang=-1) %>%
	set("leaves_pch", 19) %>%   # type of marker
	set("leaves_cex", leafSize) %>% #Size
	set("leaves_col", leafColors[leafType]) # up or down genes

  plot(dend,horiz=TRUE)
  legend("top",pch=19, col=leafColors[1:2],legend=levels(leafType),bty = "n",horiz =T  )
}