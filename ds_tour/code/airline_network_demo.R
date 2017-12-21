airports <- read.csv("http://datasets.flowingdata.com/tuts/maparcs/airports.csv", header=TRUE)
flights <- read.csv("http://datasets.flowingdata.com/tuts/maparcs/flights.csv", header=TRUE, as.is=TRUE)

pal <- colorRampPalette(c("#f2f2f2", "black"))
colors <- pal(100)

map("world", col="#f2f2f2", fill=TRUE, bg="white", lwd=0.05, xlim=xlim, ylim=ylim)

fsub <- flights[flights$airline == "AA",]
maxcnt <- max(fsub$cnt)
for (j in 1:length(fsub$airline)) {
    air1 <- airports[airports$iata == fsub[j,]$airport1,]
    air2 <- airports[airports$iata == fsub[j,]$airport2,]
    
    inter <- gcIntermediate(c(air1[1,]$long, air1[1,]$lat), c(air2[1,]$long, air2[1,]$lat), n=100, addStartEnd=TRUE)
    colindex <- round( (fsub[j,]$cnt / maxcnt) * length(colors) )
    
    lines(inter, col=colors[colindex], lwd=0.8)
}
