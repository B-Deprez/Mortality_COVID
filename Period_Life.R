
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
User = "bruno.r.deprez@gmail.com"
pw = "Mortality3.1415"
df = hmd.mx("BEL", User , pw , "Belgium")

mortality_table <- df$pop$total

Belgian_mortality <- readr::read_delim(
  file = "Belgium.txt",
  delim = " ", col_types = "nnnnnnnnnn",
  col_names = FALSE, skip = 3) 
names(Belgian_mortality) <- c("Year", "Age", "mx", "qx", "ax", "lx", "dx", "Lx", "Tx", "ex")
