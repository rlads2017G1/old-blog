library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(grid)
options(scipen=999)

YMD <- function(x){paste(x,'-','28',sep="")}
rp <- function(x) {
    library(stringr)
    str_replace_all(x,"Mainland","China")}
#--------------------------------------------

taiwan_tour <- read_csv("./data/taiwan_tour_to_foreign_cleaned.csv") %>%
    mutate(YMD=as.Date(YMD(Y_M)))
taiwan_tour <- taiwan_tour %>%
    separate(Country,c("Ch_Country","Country")) %>%
    mutate(Country=rp(Country))

#------------------------------------------

taiwan_tour <- taiwan_tour %>%
    separate(Country,c("Ch_Country","Country")) %>%
    mutate(Country=rp(Country))

tour_ebola_2014 <- taiwan_tour %>%
    filter(T_Y==103) %>%
    filter(grepl("美國",Ch_Country))

tour_ebola_2015 <- taiwan_tour %>%
    filter(T_Y==104) %>%
    filter(grepl("美國",Ch_Country))

tour_ebola_2013 <- taiwan_tour %>%
    filter(T_Y==102) %>%
    filter(grepl("美國",Ch_Country))

plot_2014 <- ggplot()+
    geom_line(tour_ebola_2014,mapping = aes(x=YMD, y=Cases, color="2014(Ebola)")) +
    geom_point(tour_ebola_2014,mapping = aes(x=YMD, y=Cases, color="2014(Ebola)")) +
    scale_color_manual(values="#EA0000") +  
    scale_x_date(labels = function(x) format(x, "%h"), date_breaks="1 month") +
    labs(x = "", y="", colour = "Number of travelers")

plot_2013 <- ggplot()+
    geom_line(tour_ebola_2013,mapping = aes(x=YMD, y=Cases, color="2013")) +
    geom_point(tour_ebola_2013,mapping = aes(x=YMD, y=Cases, color="2013")) +
    scale_color_manual(values="#FF359A") +  
    scale_x_date(labels = function(x) format(x, "%h"), date_breaks="1 month") +
    labs(x = "", y="", colour = "Number of travelers")

plot_2015 <- ggplot()+
    geom_line(tour_ebola_2015,mapping = aes(x=YMD, y=Cases, color="2015")) +
    geom_point(tour_ebola_2015,mapping = aes(x=YMD, y=Cases, color="2015")) +
    scale_color_manual(values="#9F35FF") +  
    scale_x_date(labels = function(x) format(x, "%h"), date_breaks="1 month") +
    labs(x = "", y="", colour = "Number of travelers")

grid.newpage()
grid.draw(rbind(ggplotGrob(plot_2013), ggplotGrob(plot_2014), ggplotGrob(plot_2015), size = "last"))
