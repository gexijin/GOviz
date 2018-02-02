# GOviz
This is a program that visualize results from enrichment analysis based on Gene Ontology etc.
It plots enrichment results by highlighting the similarities among terms

See example [input file.](https://raw.githubusercontent.com/gexijin/GOviz/master/enrichedGOTerms.csv "Logo Title Text 1")

Output is this tree:
![alt text](https://raw.githubusercontent.com/gexijin/GOviz/master/enrichmentPlot.png "Logo Title Text 1")

Usage:
```R
source("https://raw.githubusercontent.com/gexijin/GOviz/master/GOviz.R")
install.packages("dendextend")
enrichedTerms = read.csv("enrichedGOTerms.csv")
enrichmentPlot(enrichedTerms,36)
```

