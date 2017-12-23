library(readr)
library(dplyr)
library(lubridate)

mers_Korea <- read_csv("./data/mers_Korea.csv") %>%
    rename("date"=`[hide]Date`, "cum_case"=`Cases*1*2`, "cum_death"=`Deaths*2`)
mers_Korea <- mers_Korea %>%    
    mutate(date=dmy(mers_Korea$date)) %>%
    filter(date!=is.na(mers_Korea$date)) %>%
    mutate(case=lead(cum_case)-cum_case) %>%
    mutate(death=lead(cum_death)-cum_death) %>%
    replace_na(list(case=0, death=0)) %>%
    mutate(month=month(date)) %>%
    select(month, date, case, death, everything()) ## reorder columns, everything() select

write_csv(mers_Korea, path = "./data/mers_Korea_cleaned.csv")


