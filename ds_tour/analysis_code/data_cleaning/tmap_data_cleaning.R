library(readr)
library(dplyr)
library(stringi)
rp <- function(x, origin, replace) {stri_replace_all_fixed(x,origin,replace)}

tour <- read_csv("./data/tour.csv",col_names = FALSE) %>%
    rename("year"=X1,"country"=X2,"count"=X3) %>%
    mutate(year=1911+year) 

# tour_code <- left_join(tour,iso_a3_ch,by="country") %>%
#     filter(year==2015) %>%
#     filter(!grepl("地區",country))
# 
# tour_code <- tour_code[is.na(tour_code$iso_a3),]
# write_csv(tour_code,"./NA.Codes.csv")

NA_Codes <- read_csv("./data/NA.Codes.csv")
correct_code <- NA_Codes[,c(2,5)]
correct_code <- correct_code[!is.na(correct_code$iso_a3_ch.csv),]   
for (i in 1:nrow(correct_code)){
    tour <- tour %>%
        mutate(country=rp(country,correct_code[i,1],correct_code[i,2]))
}

iso_a3_ch <- read_csv("./data/iso_a3_ch.csv")
iso_a3_ch <- iso_a3_ch[,c(2,5)]
colnames(iso_a3_ch) <- c("iso_a3","country")

tour_code <- left_join(tour,iso_a3_ch,by="country")
tour_code <- tour_code[!is.na(tour_code$iso_a3),]

write_csv(tour_code, "./visualization/data/TourCount_CountryCode.csv")



