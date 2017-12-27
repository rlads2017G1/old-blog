setwd("C:/Users/user/DS_project/liao")
library(tmap)
library(tmaptools)
library(readr)
library(dplyr)
library(leaflet)
library(sp)
library(xts)
options(scipen=999)

tour_code <- read_csv("./visualization/data/TourCount_CountryCode.csv")

tour_code.2015 <- tour_code %>% filter(year==2015) %>% select(iso_a3,count)
tour_code.2014 <- tour_code %>% filter(year==2014) %>% select(iso_a3,count)
tour_code.2013 <- tour_code %>% filter(year==2013) %>% select(iso_a3,count)
tour_code.2012 <- tour_code %>% filter(year==2012) %>% select(iso_a3,count)
tour_code.2011 <- tour_code %>% filter(year==2011) %>% select(iso_a3,count)
tour_code.2010 <- tour_code %>% filter(year==2010) %>% select(iso_a3,count)


data("World")

World.2015 <- append_data(World,tour_code.2015, key.shp="iso_a3",key.data="iso_a3", ignore.na=T)
World.2014 <- append_data(World,tour_code.2014, key.shp="iso_a3",key.data="iso_a3", ignore.na=T)
World.2013 <- append_data(World,tour_code.2013, key.shp="iso_a3",key.data="iso_a3", ignore.na=T)
World.2012 <- append_data(World,tour_code.2012, key.shp="iso_a3",key.data="iso_a3", ignore.na=T)
World.2011 <- append_data(World,tour_code.2011, key.shp="iso_a3",key.data="iso_a3", ignore.na=T)
World.2010 <- append_data(World,tour_code.2010, key.shp="iso_a3",key.data="iso_a3", ignore.na=T)



### Use Leaflet
World.2015 <- spTransform(World.2015, CRS("+init=epsg:4326"))
World.2014 <- spTransform(World.2014, CRS("+init=epsg:4326"))
World.2013 <- spTransform(World.2013, CRS("+init=epsg:4326"))
World.2012 <- spTransform(World.2012, CRS("+init=epsg:4326"))
World.2011 <- spTransform(World.2011, CRS("+init=epsg:4326"))
World.2010 <- spTransform(World.2010, CRS("+init=epsg:4326"))

bins <- c(100, 5000, 10000, 50000, 100000, 200000, 500000, 1000000, 3000000, 4000000)
pal <- colorBin("YlOrRd", domain = World.2015$count, bins = bins)

pl.World.year <- function(World.year, lon=12, lat=35, zoom=1.55, Legend.title="Travelers") {
    labels <- sprintf("<strong>%s</strong><br/>%g people",
                      World.year$name, World.year$count) %>% 
        lapply(htmltools::HTML)
    
    pl <- leaflet(World.year) %>%
        setView(lon,lat,zoom=zoom) %>%
        addPolygons(data=World.year,
                    fillColor = ~pal(count),
                    weight = 2,
                    opacity = 1,
                    color = "white",
                    dashArray = "3",
                    fillOpacity = 0.7,
                    highlight = highlightOptions(
                        weight = 5,
                        color = "#666",
                        dashArray = "",
                        fillOpacity = 0.7,
                        bringToFront = TRUE),
                    label = labels,
                    labelOptions = labelOptions(
                        style = list("font-weight" = "normal", padding = "3px 8px"),
                        textsize = "15px",
                        direction = "auto")) %>%
        addLegend(pal = pal, values = ~count, opacity = 0.7,
                  position = "bottomleft", title = Legend.title)
    }



# labels <- sprintf(
#     "<strong>%s</strong><br/>%g people",
#     World.2015$name, World.2015$count
# ) %>% lapply(htmltools::HTML)
# 
# World_2015 <- leaflet(World.2015) %>%
#     setView(10,20,zoom=1.4) %>%
#     addPolygons(data=World.2015,
#         fillColor = ~pal(count),
#         weight = 2,
#         opacity = 1,
#         color = "white",
#         dashArray = "3",
#         fillOpacity = 0.7,
#         highlight = highlightOptions(
#             weight = 5,
#             color = "#666",
#             dashArray = "",
#             fillOpacity = 0.7,
#             bringToFront = TRUE),
#         label = labels,
#         labelOptions = labelOptions(
#             style = list("font-weight" = "normal", padding = "3px 8px"),
#             textsize = "15px",
#             direction = "auto")) %>%
#     addLegend(pal = pal, values = ~count, opacity = 0.7,
#               position = "bottomleft", title = "Travelers (2015)")
#     


# tmap_mode("view")

# World_2015 <- tm_shape(World.2015) +
#     tm_fill("count", title = "Travelers from Taiwan", style = "fixed",
#             breaks = c(100, 5000, 10000, 50000, 100000, 200000, 500000, 1000000, 3000000, 4000000)
#     ) +
#     tm_borders() +
# tm_layout(legend.position = c("left","bottom"))
# 
# 
# World_2014 <- tm_shape(World.2014) +
#     tm_fill("count", title = "Travelers from Taiwan", style = "fixed",
#             breaks = c(100, 5000, 10000, 50000, 100000, 200000, 500000, 1000000, 3000000, 4000000),
#     ) +
#     tm_borders() +
#     tm_layout(legend.show = F)
# 
# World_2015 + World_2014