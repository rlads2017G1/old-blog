library(readr)
library(ggplot2)
library(plotly)
library(grid)
library(tidyr)
library(stringr)
library(lubridate)
options(scipen=999)

YMD <- function(x){paste(x,'-',28,sep="")}

h1n1 <- read_csv("./data/H1N1_cleaned.csv") %>%
    mutate(YMD=as.Date(YMD(Y_M)))

rp <- function(x) {
    library(stringr)
    str_replace_all(x,"Mainland","China")}

taiwan_tour <- read_csv("./data/taiwan_tour_to_foreign_cleaned.csv") %>%
    mutate(YMD=as.Date(YMD(Y_M))) %>%
    separate(Country,c("Ch_Country","Country")) %>%
    mutate(Country=rp(Country))

h1n1_global <- h1n1 %>%
    group_by(Y_M,Country) %>%
    summarise(Cases=sum(Cases,na.rm = TRUE)) %>%
    mutate(YMD=as.Date(YMD(Y_M)))

h1n1_asia <- h1n1_global %>%
    filter(grepl("Republic of Korea",Country)) #Republic of Korea|China|Japan|Thailand|Indonesia|Singapore|Malaysia
    # filter(grepl("Republic of Korea|China|Japan",Country))
# China|Japan|Republic of Korea|Hong Kong|Thailand|Indonesia|Singapore|Malaysia
    
## 2009 2010 tour to Asisan countries by month
tour_asia_country_09_10 <- taiwan_tour %>%
    filter(T_Y==98|T_Y==99) %>%
    filter(grepl("Korea",Country))  # "中國|日本|韓國|香港|澳門"
    # filter(grepl("China|Japan|Korea",Country))

## 2008 2009 tour to Asisan countries by month
tour_asia_country_08_09 <- taiwan_tour %>%
    filter(T_Y==97|T_Y==98) %>%
    filter(grepl("Korea",Country))

## 2010 2011 tour to Asisan countries by month
tour_asia_country_10_11 <- taiwan_tour %>%
    filter(T_Y==99|T_Y==100) %>%
    filter(grepl("Korea",Country))



## plot h1n1 and 09_10 together

plot_h1n1 <- ggplot(h1n1_asia,mapping = aes(x=YMD, y=Cases, color=Country))+
    geom_line() +
    geom_point() +
    scale_x_date(labels = function(x) format(x, "%Y-%m"))

plot_08_09 <- ggplot(tour_asia_country_08_09,mapping = aes(x=YMD, y=Cases, color=Country))+
    geom_line() +
    geom_point() +
    scale_x_date(labels = function(x) format(x, "%Y-%m"))

plot_09_10 <- ggplot(tour_asia_country_09_10,mapping = aes(x=YMD, y=Cases, color=Country))+
    geom_line() +
    geom_point() +
    scale_x_date(labels = function(x) format(x, "%Y-%m"))

plot_10_11 <- ggplot(tour_asia_country_10_11,mapping = aes(x=YMD, y=Cases, color=Country))+
    geom_line() +
    geom_point() +
    scale_x_date(labels = function(x) format(x, "%Y-%m"))


grid.newpage()
grid.draw(rbind(ggplotGrob(plot_08_09), ggplotGrob(plot_10_11), ggplotGrob(plot_09_10), ggplotGrob(plot_h1n1), size = "last"))
