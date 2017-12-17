library(dplyr)
library(readr)
library(stringr)
library(ggplot2)
options(scipen=999)

## 各大洲"合計"  "地區"意義相同  統一為"地區"
lo<- function(x) {str_replace_all(x,"合計","地區")}

tour <- read_csv("tour.csv", col_names = FALSE) %>%
    rename("Year"=X1,"Location"=X2,"Count"=X3) %>%
    mutate(Location=lo(Location)) #將"合計"統一為"地區"

## 各大洲數據(不含其他地區)
tour_continent <- tour %>%
    filter(grepl("地區",Location)) %>%
    filter(!grepl("其他地區",Location))

## 各國家
tour_state <- tour %>%
    filter(!grepl("其他|地區|合計|未列明",Location))

## 旅遊總人數
non_region <- tour %>%
    filter(!grepl("地區",Location)) 

other_region <- tour %>%
    filter(grepl("其他地區",Location))

tour_total <- bind_rows(non_region, other_region) %>%
    group_by(Year) %>%
    summarise(Total=sum(Count,na.rm = TRUE))



## 各大洲旅遊人數比較
gp=ggplot(tour_continent,mapping = aes(x=Year, y=Count))+
    geom_line(mapping = aes(color=Location))+
    scale_x_continuous(breaks=69:104)
ggplotly(gp)

## 各大洲+總人數
gp=ggplot()+
    geom_line(data=tour_continent,mapping = aes(x=Year,y=Count,color=Location))+
    geom_line(data=tour_total, mapping=aes(x=Year,y=Total,color="總人數"))+
    scale_x_continuous(limits=c(75,104),breaks=75:104)
ggplotly(gp)
