
# Loading packages and setting directory
library(tidyverse)
library(dplyr)
library(demography)
library(ggplot2)
library(gridExtra)

library(foreign)
library(systemfit)
library(MASS)

dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(dir)

## Reading in database
# This is used to have an accurate view on population size
User = "***"
pw = "***"
df = hmd.mx("BEL", User , pw , "Belgium")

#Table with data from online
mortality_table <- df$pop$total

#Overview of mortality data from txt-file downloaded from HMD
Belgian_mortality <- readr::read_delim(
  file = "Belgium.txt",
  delim = " ", col_types = "nnnnnnnnnn",
  col_names = FALSE, skip = 3) 
names(Belgian_mortality) <- c("Year", "Age", "mx", "qx", "ax", "lx", "dx", "Lx", "Tx", "ex")

#First look at mortality evolution using the curves
ages <- 0:110
mx_2019 <- (Belgian_mortality %>% filter(Year == 2019))$mx
mx_2020 <- (Belgian_mortality %>% filter(Year == 2020))$mx

#Add it in a matrix
mx <- cbind(ages, mx_2019, mx_2020)
mx <- data.frame(mx)

#Plot
colors <- c('2019' = 'blue', '2020' = 'red')

q <- ggplot(mx, aes(x = ages)) +
  geom_line(aes(y = mx_2019, color = '2019'), size = 1) +
  geom_line(aes(y = mx_2020, color = '2020'), size = 1) +
  scale_y_log10() +
  scale_color_manual(values = colors)+
  scale_x_continuous(
    breaks =
      seq(ages[1], tail(ages, 1) + 1,
          10)) +
  labs(x = "Age (x)",y = "Force of Mortality (mx)", color = "Year", title = "Belgian Mortality")+
  theme_bw()
q

#Life expectancy
ex_2019 <- (Belgian_mortality %>% filter(Year == 2019))$ex
ex_2020 <- (Belgian_mortality %>% filter(Year == 2020))$ex

#Add it in a matrix
ex <- cbind(ages, ex_2019, ex_2020)
ex <- data.frame(ex)

#Plot
e <- ggplot(ex, aes(x = ages)) +
  geom_line(aes(y = ex_2019, color = '2019'), size = 1) +
  geom_line(aes(y = ex_2020, color = '2020'), size = 1) +
  scale_color_manual(values = colors)+
  scale_x_continuous(
    breaks =
      seq(ages[1], tail(ages, 1) + 1,
          10)) +
  labs(x = "Age (x)",y = "Life Expectancy at Exact Age (ex)", color = "Gender", title = "Life Expectancy at Exact Age for Belgium")+
  theme_bw()
e

change <- ex_2020-ex_2019
plot(change, type = "l", main= "Change in life expectancy")
