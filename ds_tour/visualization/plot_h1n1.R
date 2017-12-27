library(readr)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(plotly)
library(dygraphs)
library(flexdashboard)
library(RColorBrewer)
library(scales)
library(xts)

# hue_pal()(4) # function to generate ggplot palette, 4 indicates 4 colors

h1n1_global <- read_csv("./visualization/data/h1n1_global_08_11.csv")

taiwan_tour_month <- read_csv("./visualization/data/taiwan_tour_byMonth.csv")

## function: tour to Asisan countries by month
tour_year_country <- function(date=c(98,97),country="Korea") {
    tour_year_country <- taiwan_tour_month %>%
        filter(T_Y==date[1]|T_Y==date[2]) %>%
        filter(grepl(country,Country)) %>% # "中國|日本|韓國|香港|澳門"
        # filter(grepl("China|Japan|Korea",Country))
        rename("Count"=Cases)
    }

h1n1_country <- function(country="Republic of Korea") {
    h1n1_country <- h1n1_global %>%
        filter(grepl(country,Country)) #Republic of Korea|China|Japan|Thailand|Indonesia|Singapore|Malaysia
        # filter(grepl("Republic of Korea|China|Japan",Country))
        # China|Japan|Republic of Korea|Hong Kong|Thailand|Indonesia|Singapore|Malaysia
}

#---Plotting---------
tour_2009_10_Korea <- tour_year_country(c(98,99),"Korea") %>% select(YMD, Count)
h1n1_Korea <- h1n1_country("Republic of Korea") %>% select(YMD, Cases)
Korea <- left_join(tour_2009_10_Korea,h1n1_Korea,by="YMD") %>% mutate(Count=Count/100)
Korea <- xts(Korea, order.by=(Korea$YMD))[,-1]

tour_2009_10_Japan <- tour_year_country(c(98,99),"Japan") %>% select(YMD, Count)
h1n1_Japan <- h1n1_country("Japan") %>% select(YMD, Cases)
Japan <- left_join(tour_2009_10_Japan,h1n1_Japan,by="YMD") %>% mutate(Count=Count/100)
Japan <- xts(Japan, order.by=(Japan$YMD))[,-1]


dygraph(Korea, main = "Korea", group = "H1N1") %>%
    dyOptions(axisLabelFontSize = 12, axisLineWidth = 0.8, drawGrid=F) %>%
    dySeries("Cases", axis = 'y2', label = "H1N1病例", color = hue_pal()(2)[1]) %>%
    dySeries("Count", axis = 'y', label = "旅遊人數(百人)", color=hue_pal()(2)[2]) %>%
    dyAxis("y", label = "旅遊人數(百)",axisLabelColor = hue_pal()(2)[2]) %>%
    dyAxis("y2", label = "H1N1病例",axisLabelColor = hue_pal()(2)[1],independentTicks = TRUE) %>%
    dyRangeSelector(height = 20, strokeColor = "") %>%
    dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
    dyLegend(labelsSeparateLines=T)

dygraph(Japan, main = "Japan", group = "H1N1") %>%
    dyOptions(axisLabelFontSize = 12, axisLineWidth = 0.8, drawGrid=F) %>%
    dySeries("Cases", axis = 'y2', label = "H1N1病例", color = hue_pal()(2)[1]) %>%
    dySeries("Count", axis = 'y', label = "旅遊人數(百人)", color=hue_pal()(2)[2]) %>%
    dyAxis("y", label = "旅遊人數(百)",axisLabelColor = hue_pal()(2)[2]) %>%
    dyAxis("y2", label = "H1N1病例",axisLabelColor = hue_pal()(2)[1],independentTicks = TRUE) %>%
    dyRangeSelector(height = 20, strokeColor = "") %>%
    dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
    dyLegend(labelsSeparateLines=T)

dygraph(Japan, main = "Japan", group = "H1N1")
dygraph(Korea, main = "Korea", group = "H1N1")
