library(countrycode)
library(readr)
library(dplyr)
library(stringr)
library(stringi)
rp <- function(x, origin, replace) {stri_replace_all_fixed(x,origin,replace)}


# col <- read_csv("./data/global_airline_network/col.csv", col_names = FALSE)
# col <- as.vector(as.matrix(col))
# 
# airports <- read_csv("./data/global_airline_network/airports.csv", col_names = FALSE)
# airports <- as.data.frame(airports)
# 
# colnames(airports) <- col
# 
# write_csv(airports, "./data/global_airline_network/airports_col.csv")

airports <- read_csv("./data/global_airline_network/airports_col.csv", col_names = TRUE) %>%
    mutate("Continent"=Country) %>% # add new column
    mutate("ISO_3166"=Country) %>%
    mutate("Sub_continent"=Country)

country_3166 <- read_csv("./data/global_airline_network/ISO_3166_with_continent.csv")  %>%
    mutate(name=rp(name,"United States of America","United States")) %>%
    mutate(name=rp(name,"United Kingdom of Great Britain and Northern Ireland","United Kingdom")) %>%
    mutate(name=rp(name,"Tanzania, United Republic of","Tanzania"))  %>%
    mutate(name=rp(name,"Russian Federation","Russia")) %>%
    mutate(name=rp(name,"Korea (Republic of)","South Korea")) %>%
    mutate(name=rp(name,"Korea (Democratic People's Republic of)","North Korea")) %>% 
    mutate(name=rp(name,"Venezuela (Bolivarian Republic of)","Venezuela")) %>%
    mutate(name=rp(name,"Taiwan, Province of China","Taiwan")) %>% 
    mutate(name=rp(name,"Russian Federation","Russia")) %>%
    mutate(name=rp(name,"Iran (Islamic Republic of)","Iran")) %>% 
    mutate(name=rp(name,"Moldova (Republic of)","Moldova")) %>% 
    mutate(name=rp(name,"Congo (Democratic Republic of the)","Congo (Kinshasa)")) %>% 
    mutate(name=rp(name,"Bolivia (Plurinational State of)","Bolivia")) %>% 
    mutate(name=rp(name,"Myanmar","Burma")) %>% 
    mutate(name=rp(name,"Svalbard and Jan Mayen","Svalbard")) %>%
    mutate(name=rp(name,"Virgin Islands (U.S.)","Virgin Islands")) %>% 
    mutate(name=rp(name,"Virgin Islands (British)","British Virgin Islands")) %>% 
    mutate(name=rp(name,"Brunei Darussalam","Brunei")) %>% 
    add_row(name="Vietnam",`alpha-2`="VN",`alpha-3`=NA,`country-code`=NA,`iso_3166-2`="ISO 3166-2:VN",region="Asia",`sub-region`="South-Eastern Asia",`region-code`=NA,`sub-region-code`=NA) %>%## add Vietnam
    add_row(name="Laos",`alpha-2`="LA",`alpha-3`=NA,`country-code`=NA,`iso_3166-2`="ISO 3166-2:LA",region="Asia",`sub-region`="South-Eastern Asia",`region-code`=NA,`sub-region-code`=NA) ## add Vietnam

country_3166[which(country_3166$name=="Namibia"),2] <- "NA"

    
# which(is.na(airports$ISO_3166)==TRUE)  # For Checking

# country <- read_csv("./data/global_airline_network/countries_iso3166-1.csv", col_names = FALSE)
# names(country) <- c("Country", "ISO_3166","X3","X4")

## assign ISO-3166-1 to every country
for (i in 1:nrow(airports)){
    index <- airports[i,]$Country==country_3166$name
    s_index <- which(index==TRUE)
    
    if (length(s_index)==0){
        airports[i,]$ISO_3166 <- NA
    }else {
        airports[i,]$ISO_3166 <- country_3166[s_index,]$`alpha-2`
    }
}

## asign continents of each airport according to country name
for (i in 1:nrow(airports)){
    index <- airports[i,]$Country==country_3166$name
    s_index <- which(index==TRUE)
    
    if (length(s_index)==0){
        airports[i,]$Continent <- NA
    }else {
        airports[i,]$Continent <- country_3166[s_index,]$region
    }
}

## asign sub-region of each airport according to country name
for (i in 1:nrow(airports)){
    index <- airports[i,]$Country==country_3166$name
    s_index <- which(index==TRUE)
    
    if (length(s_index)==0){
        airports[i,]$Sub_continent <- NA
    }else {
        airports[i,]$Sub_continent <- country_3166[s_index,]$`sub-region`
    }
}

write_csv(airports, "./data/global_airline_network/airports_with_continent.csv")
