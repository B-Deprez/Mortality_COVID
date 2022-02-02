
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

mortality_table <- df$pop$total

