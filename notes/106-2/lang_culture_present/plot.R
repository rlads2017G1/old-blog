library(timevis)

## Dis- vs. Un-: meaning change  line_dis_un---------
group_dis.un <- data.frame(
    id      = c("dis","un"),
    content = c("Dis-<br>interested", 
                "Un-<br>interested"),
    title = c("Dis-", "Un-"),
    style   = c("background-color:rgba(248,118,109,0.7)","background-color:rgba(0,191,196,0.7)")
)

meaning <- data.frame(
    id      = 1:4,
    content = c("<b>unconcerned, <br>indifferent<b>", 
                "impartial, unbiased",
                "impartial, unbiased",
                "<b>unconcerned, <br>indifferent<b>"),
    start   = c("1600-01-01", "1650-01-01", "1650-01-01", "1750-01-01"),
    end     = c("1670-01-01", "1900-05-08", "1770-01-01", "1900-05-08"),
    group   = c("dis","dis","un","un")
    
)

line_dis_un <- timevis(meaning, groups  = group_dis.un) %>% setGroups(group_dis.un)

## pie: disinterested pie_US pie_UK------------------
library(dplyr)
percent <- tibble(
    UK = c(25, 75), 
    US = c(50, 50.0001),
    meaning = c("bored", "others"))
 
library(plotly)
plot_ly(percent, labels = ~meaning, values = ~UK, type = 'pie') %>%
    layout(title = 'The Meaning of "disinterested" in UK',
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)', 'rgb(114,147,203)')

pie_UK <- plot_ly(percent, labels = ~meaning, values = ~UK, type = 'pie',
             textposition = 'inside',
             textinfo = 'label+percent',
             insidetextfont = list(color = '#FFFFFF'),
             marker = list(colors = colors,
                           line = list(color = '#FFFFFF', width = 1)),
             showlegend = FALSE) %>%
    layout(title = 'The Meaning of "disinterested" in UK',
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

pie_US <- plot_ly(percent, labels = ~meaning, values = ~US, type = 'pie',
                textposition = 'inside',
                textinfo = 'label+percent',
                insidetextfont = list(color = '#FFFFFF'),
                marker = list(colors = colors,
                              line = list(color = '#FFFFFF', width = 1)),
                showlegend = FALSE) %>%
    layout(title = 'The Meaning of "disinterested" in US',
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))