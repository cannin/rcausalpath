#' Generate igraph Graph with node, edge colors and highlighted nodes.
#'
#' @param sif Network which is loaded in graph and gets colors assigned
#' @param formatFile File path of the .format file with information about the colors of the nodes
#' @param highlightNodes Vector containing names of nodes which are highlighted by a circle node instead of rectangles
#' @param formatConfFile File path of .format file of conflicting network to plot merged network. Required for
#' color of nodes which are only present in subnetwork which was added from the conflicting network.
#'
#' @return igraph graph object with adapted colors
#'
#' @concept rcausalpath
#' @export
#' 
#' @importFrom paxtoolsr loadSifInIgraph
loadCausalPathFormat <- function(sif,formatFile,highlightNodes = NULL,formatConfFile = NULL) {
  require(paxtoolsr)
  require(igraph)

  # load sif in graph
  g <- loadSifInIgraph(sif)

  # load format file
  format <- read.delim(formatFile, header=FALSE, stringsAsFactors=FALSE)
  format <- format[,-1]

  # load format file for conflicting subnetwork added in network
  if(!is.null(formatConfFile)){
    formatConf <- read.delim(formatConfFile, header=FALSE, stringsAsFactors=FALSE)
    formatConf <- formatConf[,-1]
  }

  # Node colors and shape
  nodeColors <- NULL
  nodeShapes <- NULL
  for(i in 1:length(V(g))){
    if(length(which(V(g)$name[i]==highlightNodes))>0){
      nodeShapes <- c(nodeShapes, "circle")
    }else{
      nodeShapes <- c(nodeShapes, "rectangle")
    }
    idx <- which(format$V2==names(V(g)[i]) & format$V3=="color")
    if(length(idx)==1){
      rgbTmp <- strsplit(format$V4[idx], " ")[[1]]

      # Values must be between 0 and 1
      t1 <- as.numeric(rgbTmp) / 255
      hexColor <- do.call("rgb", as.list(t1))

      nodeColors <- c(nodeColors, hexColor)
    } else if(!is.null(formatConfFile)){
      if(length(which(formatConf$V2==names(V(g)[i]) & formatConf$V3=="color"))>0){
        idx <- which(formatConf$V2==names(V(g)[i]) & formatConf$V3=="color")
        rgbTmp <- strsplit(formatConf$V4[idx], " ")[[1]]

        # Values must be between 0 and 1
        t1 <- as.numeric(rgbTmp) / 255
        hexColor <- do.call("rgb", as.list(t1))

        nodeColors <- c(nodeColors, hexColor)
      }
      else{
        nodeColors <- c(nodeColors, "#FFFFFF")
      }
    }
    else{
      nodeColors <- c(nodeColors, "#FFFFFF")
    }
  }

  # Assign to graph
  V(g)$color <- nodeColors
  V(g)$shape <- nodeShapes

  # Edge colors and style
  edgeColors <- NULL
  edgeLty <- NULL

  for(idx in 1:length(E(g))){
    if(sif$INTERACTION_TYPE[idx]=="upregulates-expression"){
      edgeLty <- c(edgeLty, 2)
      edgeColors <- c(edgeColors, "#006400")
    }
    if(sif$INTERACTION_TYPE[idx]=="downregulates-expression"){
      edgeLty <- c(edgeLty, 2)
      edgeColors <- c(edgeColors, "#640000")
    }
    if(sif$INTERACTION_TYPE[idx]=="phosphorylates"){
      edgeLty <- c(edgeLty, 1)
      edgeColors <- c(edgeColors, "#006400")
    }
    if(sif$INTERACTION_TYPE[idx]=="dephosphorylates"){
      edgeLty <- c(edgeLty, 1)
      edgeColors <- c(edgeColors, "#640000")
    }

    # for merged sif of causative and (parts of the) conflicting network, the extension of the interaction type
    # "-conf" indicates that the edges are added from the conflicting network. These edges are highlighted with
    # different colors than the causative network.

    if(sif$INTERACTION_TYPE[idx]=="upregulates-expression-conf"){
      edgeLty <- c(edgeLty, 1)
      edgeColors <- c(edgeColors, "#FF00FF")
    }
    if(sif$INTERACTION_TYPE[idx]=="downregulates-expression-conf"){
      edgeLty <- c(edgeLty, 1)
      edgeColors <- c(edgeColors, "#00FFFF")
    }
  }

  # Assign to graph
  E(g)$color <- edgeColors
  E(g)$lty <- edgeLty

  return(g)
}
