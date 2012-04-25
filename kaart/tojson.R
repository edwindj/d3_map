
# convert map to json

library(maptools)

map <- readShapePoly("gm_2010.shp")

polygons <- attr(map, "polygons")

rangemax <- c(NA, NA)
rangemin <- c(NA, NA)

for (i in 1:length(polygons)) {
  pols <- polygons[[i]]@Polygons
  for (j in 1:length(pols)) {
    coords <- pols[[j]]@coords
    rangemin <- apply(rbind(rangemin, coords), 2, min, na.rm=TRUE)
    rangemax <- apply(rbind(rangemax, coords), 2, max, na.rm=TRUE)
  }
}

foo$polygons[[1]]@Polygons[[1]]@coords

