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

## filter 出亞洲國家
tour_asia_country <- tour %>%
    filter(grepl("中國|日本|韓國|香港|亞洲地區|菲律賓|新加坡|馬來西亞|泰國|印尼|汶萊|越南|澳門|緬甸",Location))

## 圖:亞洲國家
gp=ggplot(tour_asia_country,mapping = aes(x=Year, y=Count))+
    geom_point(mapping = aes(color=Location))+
    scale_x_continuous(limits=c(75,104) ,breaks=69:104)
ggplotly(gp)

## 歐洲
tour_euro_country <- tour %>%
    filter(grepl("中國|日本|韓國|香港|亞洲地區|菲律賓|新加坡|馬來西亞|泰國",Location))

View(tour %>%
    filter(Year==104))
