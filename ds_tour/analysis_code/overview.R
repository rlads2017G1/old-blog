library(dplyr)
library(readr)
library(stringr)
library(ggplot2)
options(scipen=999)

## 各大洲"合計"  "地區"意義相同  統一為"地區"
lo<- function(x) {str_replace_all(x,"合計","地區")}

tour <- read_csv("tour.csv", col_names = FALSE) %>%
    rename("Year"=X1,"Location"=X2,"Count"=X3) %>%
    mutate(year=as.Date(paste(Year+1911,"-01-01", sep=""))) %>%
    mutate(Location=lo(Location)) #將"合計"統一為"地區"

## 各大洲數據(不含其他地區)
tour_continent <- tour %>%
    filter(grepl("地區",Location)) %>%
    filter(!grepl("其他地區",Location))

## 各國家
tour_state <- tour %>%
    filter(!grepl("其他|地區|合計|未列明",Location))

## tour Country
tour_country <- function(country) {
    tour_country <- tour %>%
        filter(grepl(country, Location))
    }

tour_amer <- tour_country("美洲地區") %>%
    filter(!grepl("中|北|南",Location))

## 旅遊總人數
non_region <- tour %>%
    filter(!grepl("地區",Location)) 

other_region <- tour %>%
    filter(Location=="其他地區")

tour_total <- bind_rows(non_region, other_region) %>%
    group_by(year) %>%
    summarise(Count=sum(Count,na.rm = TRUE))

tour_total_2 <- bind_rows(non_region, other_region) %>%
    filter(!grepl("中國|香港|日本|澳門|韓國|泰國|新加坡|越南|印尼|馬來西亞",Location)) %>%
    group_by(year) %>%
    summarise(Count=sum(Count,na.rm = TRUE))

tour_Asia_2 <- bind_rows(non_region, other_region) %>%
    filter(grepl("中國|香港|日本|澳門|韓國|泰國|新加坡|越南|印尼|馬來西亞",Location)) %>%
    group_by(year) %>%
    summarise(Count=sum(Count,na.rm = TRUE))


## Plotting Function

tour_others <- tour %>%filter(Location=="其他地區")

gp=ggplot()+
    geom_line(data=tour_total, mapping=aes(x=year,y=Count,color="總人數"))+
    # geom_line(data=tour_country("美國"), mapping=aes(x=year,y=Count,color="美國"))+
    # geom_line(data=tour_country("香港"), mapping=aes(x=year,y=Count,color="香港"))+
    # geom_line(data=tour_country("日本"), mapping=aes(x=year,y=Count,color="日本"))+
    # geom_line(data=tour_country("澳門"), mapping=aes(x=year,y=Count,color="澳門"))+
    # geom_line(data=tour_country("韓國"), mapping=aes(x=year,y=Count,color="南韓"))+
    geom_line(data=tour_country("中國"), mapping=aes(x=year,y=Count,color="中國"))+
    # geom_line(data=tour_country("泰國"), mapping=aes(x=year,y=Count,color="泰國"))+
    geom_line(data=tour_total_2, mapping=aes(x=year,y=Count,color="總人數-亞洲主要國家"))+
    geom_line(data=tour_Asia_2, mapping=aes(x=year,y=Count,color="亞洲主要國家"))+
    geom_line(data=tour_others , mapping=aes(x=year,y=Count,color="其他地區"))+
    # geom_line(data=tour_country("歐洲地區"), mapping=aes(x=year,y=Count,color="歐洲地區"))+
    # geom_line(data=tour_amer, mapping=aes(x=year,y=Count,color="美洲地區"))+
    scale_x_date(labels = function(x) format(x, "%Y"), date_breaks="2 years") +
    scale_y_continuous(breaks=seq(0, 12000000, by=1000000))
ggplotly(gp)

