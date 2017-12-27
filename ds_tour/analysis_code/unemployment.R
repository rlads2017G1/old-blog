library(readr)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(plotly)
library(dygraphs)
options(scipen=999)
Sys.setlocale("LC_TIME", "C")  # set locale to display date in en


unemployment <- read_csv("./data/unemployment.csv",col_names = FALSE) %>%
    rename("Year"=X1,"month"=X2,"rate"=X3) %>%
    mutate("Year"=1911+Year)

unemployment <- unemployment %>%
    mutate("date"=as.Date(paste(unemployment$Year,'-',unemployment$month,'-01',sep="")))

#------data: Taiwan tour to foreign, count by month--------------
YMD <- function(x){paste(x,'-','01',sep="")}
rp <- function(x) {
    library(stringr)
    str_replace_all(x,"Mainland","China")}

taiwan_tour <- read_csv("./data/taiwan_tour_to_foreign_cleaned.csv") %>%
    mutate(YMD=as.Date(YMD(Y_M)))
taiwan_tour <- taiwan_tour %>%
    separate(Country,c("Ch_Country","Country")) %>%
    mutate(Country=rp(Country))
#-------------------------------------------


# 效果不明顯
#---------2008, 2009 按月失業率 旅遊人數----------
    ## plotting parameters
tour_total <- taiwan_tour %>%
    filter(T_Y==97|T_Y==98) %>%
    filter(Ch_Country=="總計")

tour_asia <- taiwan_tour %>%
    filter(T_Y==97|T_Y==98) %>%
    filter(Ch_Country=="亞洲總計")

unem <- unemployment %>%
    filter(Year==2008|Year==2009)
    ##-------------------------
# p <- ggplot()+
#     geom_line(data=tour_total, mapping=aes(x=YMD,y=Cases/100000,color="總人數(十萬人)"))+
#     geom_line(data=unem, mapping=aes(x=date,y=rate,color="失業率(%)"))+
#     scale_x_date(labels = function(x) format(x, "%Y-%b"), date_breaks="2 months") +
#     scale_y_continuous(breaks=seq(0, 10, by=0.5))+
#     # scale_y_continuous(sec.axis = sec_axis(~./10, name = "失業率"))+
#     labs(x = "", y="", colour = "")
# ggplotly(p)
#--------------------------------------





#---------按年失業率 旅遊人數----------
    ## 各大洲"合計"  "地區"意義相同  統一為"地區"
lo<- function(x) {str_replace_all(x,"合計","地區")}

tour <- read_csv("tour.csv", col_names = FALSE) %>%
    rename("Year"=X1,"Location"=X2,"Count"=X3) %>%
    mutate(year=as.Date(paste(Year+1911,"-01-01", sep=""))) %>%
    mutate(Location=lo(Location)) #將"合計"統一為"地區"

    ## 旅遊總人數
non_region <- tour %>%
    filter(!grepl("地區",Location)) 

other_region <- tour %>%
    filter(Location=="其他地區")

tour_total_year <- bind_rows(non_region, other_region) %>%
    filter(Year>=90) %>%
    group_by(year) %>%
    summarise(Count=sum(Count,na.rm = TRUE))

    ## unemployment rate Year average
unem_year <- unemployment %>%
    filter(Year<=2015) %>%
    group_by(Year) %>%
    summarise(rate=mean(rate))
unem_year <- unem_year %>%
    mutate("date"=as.Date(paste(unem_year$Year,'-','01-01',sep="")))

    
    #-------------------------------------
# ggplot()+
#     geom_line(data=tour_total_year, mapping=aes(x=year,y=Count/1000000,color="總人數(百萬人)"))+
#     geom_point(data=tour_total_year, mapping=aes(x=year,y=Count/1000000,color="總人數(百萬人)"))+
#     geom_line(data=unem_year, mapping=aes(x=date,y=2*(rate-3),color="失業率(%)"))+
#     geom_point(data=unem_year, mapping=aes(x=date,y=2*(rate-3),color="失業率(%)"))+
#     scale_x_date(labels = function(x) format(x, "%Y"), date_breaks="1 year") +
#     scale_y_continuous(breaks=seq(0, 14, by=1),sec.axis = sec_axis(~.*0.5+3, name = "失業率(%)"))+
#     labs(x = "", y="總人數(百萬人)", colour = "")


tour_unem <- left_join(tour_total_year,unem_year, by=c("year"="date")) %>%
    mutate("date"=year) %>%
    select(date,Year,Count,rate)
    # mutate("Count"=Count/1000000) # rescale to become more readable

write_csv(tour_unem,"./visualization/data/unemployment_tour.csv") 

# tour_unem <- xts(tour_unem, order.by=tour_unem$Year)
dygraph(tour_unem) %>%
    dyAxis("y", label = "旅遊人數(百萬)") %>%
    dyAxis("y2", label = "失業率(%)", independentTicks = TRUE) %>%
    dySeries("rate", axis = 'y2', label = "失業率(%)") %>%
    dySeries("Count", axis = 'y', label = "旅遊人數(百萬)") %>%
    dyRangeSelector(height = 20, strokeColor = "") %>%
    dyHighlight(highlightSeriesOpts = list(strokeWidth = 3))
