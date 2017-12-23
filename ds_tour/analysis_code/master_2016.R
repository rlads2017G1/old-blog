library(dplyr)
library(readr)
library(stringr)
library(ggplot2)
library(plotly)
options(scipen=999)

## 各大洲"合計"  "地區"意義相同  統一為"地區"
lo<- function(x) {str_replace_all(x,"合計","地區")}

tour <- read_csv("tour.csv", col_names = FALSE) %>%
    rename("Year"=X1,"Location"=X2,"Count"=X3) %>%
    mutate(Location=lo(Location)) #將"合計"統一為"地區"


## filter 出 master card 資料(2016 top 14 cities)
tour_master <- tour %>%
    filter(grepl("泰國|英國|法國|阿拉伯聯合大公國|美國|新加坡|馬來西亞|土耳其|日本|韓國|香港|西班牙|荷蘭|義大利",Location))

gp=ggplot(tour_master,mapping = aes(x=Year, y=Count))+
    geom_line(mapping = aes(color=Location))+
    scale_x_continuous(limits=c(75,104) ,breaks=69:104)
ggplotly(gp)

## 歐洲 master 前 20
tour_master_ero <- tour %>%
    filter(grepl("英國|法國|荷蘭|捷克|奧地利|土耳其|義大利|西班牙|美國",Location))

gp=ggplot(tour_master_ero,mapping = aes(x=Year, y=Count))+
    geom_line(mapping = aes(color=Location))+
    scale_x_continuous(limits=c(75,104) ,breaks=69:104)
ggplotly(gp)