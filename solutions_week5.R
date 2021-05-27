
### EXCERCISE 5 ###

##########################################################
# Preparations
# https://github.com/hugwes/excercise_week5 (github-link)

##########################################################
# Load in Libraries
library(readr)        # to import tabular data (e.g. csv)
library(dplyr)        # to manipulate (tabular) data
library(ggplot2)      # to visualize data
library(sf)           # to handle spatial vector data (sf=shape file)
library(terra)        # to handle raster data
library(lubridate)    # to handle dates and times
library(zoo)          # moving window functions

# Import data
wildschwein <- read_delim("wildschwein_BE_2056.csv",",") %>%
  st_as_sf(coords = c("E", "N"), crs = 2056, remove = FALSE)

##########################################################
# Task 1:




