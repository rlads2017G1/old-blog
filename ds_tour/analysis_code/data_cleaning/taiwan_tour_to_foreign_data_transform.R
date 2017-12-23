library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(stringr)
library(lubridate)
#---------Functions-------------
YrMonth <- function(x){
    library(lubridate)
    paste(year(x),'-', month(x),sep='')}

rp1 <- function(x) {
    library(stringr)
    str_replace_all(x,"2009 week: ","2009-")}

rp2 <- function(x) {
    library(stringr)
    str_replace_all(x,"2010 week: ","2010-")}
#----------------------------------------------

tour_to_foreign <- read_csv("./data/taiwan_tour_to_foreign_by_month.csv")
tour_to_foreign_col <- colnames(tour_to_foreign)

tour_to_foreign <- tour_to_foreign %>%
    gather(tour_to_foreign_col[-c(1,2)], key="Country",value="Cases") %>%
    rename("Years"=`年份(Years)`,"Month"=`月份(Months)`) %>%
    separate(col = Years, c("T_Y","Year")) %>%
    unite(col=Y_M,c(Year, Month),sep = "-") 

# separate(tour_to_foreign, col = `年份(Years)`, c("Cy","Year"))
#  unite(tour_to_foreign, Year-Month,Year, Month,sep = "-") # concatinate columns

write_csv(tour_to_foreign, path = "./data/taiwan_tour_to_foreign_cleaned.csv")

