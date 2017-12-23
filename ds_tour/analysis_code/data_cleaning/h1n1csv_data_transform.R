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

h1n1 <- read_csv("./data/H1N1.csv",skip = 2)
h1n1 <- replace(h1n1[,1:ncol(h1n1)], h1n1[1:nrow(h1n1),]=='=T(" ")', NA)
h1n1_col <- colnames(h1n1)

h1n1 <- h1n1 %>%
    rename("Country"=X1) %>%
    gather(h1n1_col[-1], key="Year_Week",value="Cases") %>%
    mutate(Year_Week=rp1(Year_Week)) %>%
    mutate(Year_Week=rp2(Year_Week))
h1n1 <- replace(h1n1, h1n1[1:nrow(h1n1),]=="2009-53", "2009-52") %>% # week number of R incompatible with WHO data
    mutate(Y_M=as.Date(paste(Year_Week,1,sep="-"),"%Y-%U-%u")) %>%  # convert Year_Week to year-week-day
    mutate(Y_M=YrMonth(Y_M)) # convert year-week-day to month
    
# Year_Week=as.Date(paste(h1n1$Year_Week,1,sep="-"),"%Y-%U-%u")) %>%  # convert Year_Week to year-week-day
    
write_csv(h1n1, path = "./data/H1N1_cleaned.csv")

    

    

