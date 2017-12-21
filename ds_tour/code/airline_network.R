library(readr)
library(maps)
library(geosphere)
library(dplyr)
library(stringr)
library(stringi)
rp <- function(x, origin, replace) {stri_replace_all_fixed(x,origin,replace)}

airports <- read_csv("./data/global_airline_network/airports_with_continent.csv")

routes <- read_csv("./data/global_airline_network/routes.csv") %>%
    mutate("Source airport ID"=rp(`Source airport ID`,"\\N",NA)) %>%
    arrange(desc(`Source airport ID`)) %>%
    filter(is.na(`Source airport ID`)==F)

## Set Source Airport
WE <- airports[airports$Sub_continent == "Western Europe",] %>%
    arrange(desc(`Airport ID`)) %>%
    filter(is.na(`Airport ID`)==F) %>%
    filter(str_detect(Name, "International Airport|international airport"))


E <- airports[airports$Continent == "Europe",] %>%
    arrange(desc(`Airport ID`)) %>%
    filter(is.na(`Airport ID`)==F) %>%
    filter(str_detect(Name, "International Airport|international airport"))


EA <- airports[airports$Sub_continent == "Eastern Asia",] %>%
    arrange(desc(`Airport ID`)) %>%
    filter(is.na(`Airport ID`)==F) %>%
    filter(str_detect(Name, "International Airport|international airport"))

## filter specific airports

Inter_airport <- airports %>%
    arrange(desc(`Airport ID`)) %>%
    filter(is.na(`Airport ID`)==F) %>%
    filter(str_detect(Name, "International Airport|international airport"))

Dest_HK <- routes[routes$`Destination airport ID`=="3077",]



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

## Originate: HK airport
xlim <- c(-30, 150)
ylim <- c(-60, 85)
map("world", col="#f2f2f2", fill=TRUE, bg="white", lwd=0.01, mar = c(0.5,.5,.5,.5), ylim=ylim)
for (i in 1:nrow(Dest_HK)) {
    if (Dest_HK[i,]$`Source airport ID` %in% Inter_airport$`Airport ID` & Dest_HK[i,]$`Destination airport ID` %in% airports$`Airport ID`) {
        source_air <- Inter_airport[Inter_airport$`Airport ID`==Dest_HK[i,]$`Source airport ID`,]
        dest_air <- airports[airports$`Airport ID`==Dest_HK[i,]$`Destination airport ID`,]
        
        inter <- gcIntermediate(c(source_air[1,]$Longitude, source_air[1,]$Latitude), c(dest_air[1,]$Longitude, dest_air[1,]$Latitude), n=100, addStartEnd=TRUE)
        lines(inter, col="green", lwd=0.001)
    }
}
