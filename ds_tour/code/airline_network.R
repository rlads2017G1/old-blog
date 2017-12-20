library(readr)
library(maps)
library(geosphere)
library(dplyr)
rp <- function(x, origin, replace) {stri_replace_all_fixed(x,origin,replace)}

airports <- read_csv("./data/global_airline_network/airports_with_continent.csv")

routes <- read_csv("./data/global_airline_network/routes.csv") %>%
    mutate("Source airport ID"=rp(`Source airport ID`,"\\N",NA)) %>%
    arrange(desc(`Source airport ID`)) %>%
    filter(is.na(`Source airport ID`)==F)

## Set Source Airport
WE <- airports[airports$Sub_continent == "Western Europe",] %>%
    arrange(desc(`Airport ID`)) %>%
    filter(is.na(`Airport ID`)==F)

E <- airports[airports$Continent == "Europe",] %>%
    arrange(desc(`Airport ID`)) %>%
    filter(is.na(`Airport ID`)==F)


## Originate: Europe
xlim <- c(-30, 145)
ylim <- c(10, 70)
map("world", col="#f2f2f2", fill=TRUE, bg="white", lwd=0.01, xlim=xlim, ylim=ylim)
for (i in 1:nrow(routes)) {
    if (routes[i,]$`Source airport ID` %in% E$`Airport ID` & routes[i,]$`Destination airport ID` %in% airports$`Airport ID`) {
        source_air <- E[E$`Airport ID`==routes[i,]$`Source airport ID`,]
        dest_air <- airports[airports$`Airport ID`==routes[i,]$`Destination airport ID`,]
        
        inter <- gcIntermediate(c(source_air[1,]$Longitude, source_air[1,]$Latitude), c(dest_air[1,]$Longitude, dest_air[1,]$Latitude), n=100, addStartEnd=TRUE)
        lines(inter, col="green", lwd=0.01)
    }
}
