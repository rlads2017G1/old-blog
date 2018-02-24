library(readr)
library(ggplot2)
library(compiler)
library(microbenchmark)

# test file:  "./data/3Predator_3Pr.txt"     
#             "./data/3Predator_fluc.txt"


plot_3 <- function (file) {
    fluc <- read_delim(file, "\t",escape_double = FALSE, trim_ws = TRUE)
    fluc <- fluc[seq(1,length(fluc$time), 100),] # speed up: plot only every 10 data points from the original data
    x <- c(min(fluc$N1),min(fluc$N2),min(fluc$N3))
    names(x) <- c("Sex", "Asex1", "Asex2")
    print(x)
    View(fluc)
    
    pl <- ggplot(data=fluc,mapping = aes(x=time))+
        # geom_line(mapping = aes(y=N1,color="Sex"))+
        # geom_line(mapping = aes(y=N2,color="Asex 1"))+
        # geom_line(mapping = aes(y=N3,color="Asex 2"))+
        geom_line(mapping = aes(y=Pr1,color="Prey 1"),linetype = "dotdash" , color="blue")+
        geom_line(mapping = aes(y=Pr2,color="Prey 2"),linetype = "dotdash", color="green")+
        labs(x="Time", y="Abundance", color="")+
        theme_gray()
    pl
    # if(fluc$time[nrow(fluc)]<=500){
    #     pl + scale_x_continuous(breaks = seq(0,as.integer(fluc$time[nrow(fluc)]), 50))
    # } else {
    #     pl + scale_x_continuous(breaks = seq(0,as.integer(fluc$time[nrow(fluc)]), 200))
    # }
}




plot <- function (file) {
    fluc <- read_delim(file, "\t",escape_double = FALSE, trim_ws = TRUE)
    fluc <- fluc[seq(1,length(fluc$time), 100),] # speed up: plot only every 10 data points from the original data
    
    ggplot(data=fluc,mapping = aes(x=time))+
        geom_line(mapping = aes(y=N1,color="Sex"))+
        geom_line(mapping = aes(y=N2,color="Asex"))+
        geom_line(mapping = aes(y=Pr1,color="Prey 1"),linetype = "dotdash")+
        geom_line(mapping = aes(y=Pr2,color="Prey 2"),linetype = "dotdash")+
        labs(x="Time", y="Abundance", color="")+
        theme_gray()+
        scale_x_continuous(breaks = seq(0,as.integer(fluc$time[nrow(fluc)]), 100))
}

