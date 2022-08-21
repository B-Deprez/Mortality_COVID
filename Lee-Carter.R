
# Loading packages and setting directory
library(tidyverse)
library(dplyr)
library(ggplot2)
library(gridExtra)

library(foreign)
library(systemfit)
library(MASS)

dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(dir)

#### Reading in database ####
#Overview of mortality data from txt-file downloaded from HMD
Belgian_mortality <- readr::read_delim(
  file = "Belgium.txt",
  delim = " ", col_types = "nnnnnnnnnn",
  col_names = FALSE, skip = 3) 
names(Belgian_mortality) <- c("Year", "Age", "mx", "qx", "ax", "lx", "dx", "Lx", "Tx", "ex")

Belgian_population <- readr::read_delim(
  file = "Population.txt",
  delim = " ", col_types = "nnnnnnnnnn",
  col_names = FALSE, skip = 3) 
names(Belgian_population) <- c("Year", "Age", "Female", "Male", "Total")

max_year = max(Belgian_mortality$Year)

#### Selecting relevant data ####
#Select the population size
pop_2019 <- (Belgian_population %>% filter(Year == 2019))$Total
pop_2020 <- (Belgian_population %>% filter(Year == 2020))$Total

#Exposures are know for the life table, whare starting pop = 100000
#So we use the rule of three to get the real exposures for whole pop
#Lx from the table is used, this is "Number of person-years lived between ages x and x+1"
Lx_2019 <- (Belgian_mortality %>% filter(Year == 2019))$Lx
Lx_2020 <- (Belgian_mortality %>% filter(Year == 2020))$Lx
#Also need lx to know for how many this was calculated
lx_2019 <- (Belgian_mortality %>% filter(Year == 2019))$lx
lx_2020 <- (Belgian_mortality %>% filter(Year == 2020))$lx

#Exposure 
exp_2019 <- pop_2019*(Lx_2019/lx_2019)
exp_2020 <- pop_2020*(Lx_2020/lx_2020)

#plot exposures
ages <- (Belgian_mortality %>% filter(Year == 2019))$Age
colors <- c('2019' = 'magenta', '2020' = 'deepskyblue')
exp <- data.frame(cbind(ages, exp_2019, exp_2020))
r<- ggplot(exp, aes(x = ages)) +
  geom_line(aes(y = exp_2019, color = '2019')) +
  geom_line(aes(y = exp_2020, color = '2020')) +
  scale_color_manual(values = colors)+
  scale_x_continuous(
    breaks =
      seq(ages[1], tail(ages, 1) + 1,
          10)) +
  labs(x = "Age (x)",y = "Exposure to Risk (ex)", color = "Year", title = "Exposure to Risk for Belgium")
r + theme_bw()
