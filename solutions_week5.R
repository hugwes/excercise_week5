
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
# Task 1: Import and visualize spatial data
feldaufnahmen <- read_sf("Feldaufnahmen_Fanel.gpkg") 

# this is a vector-dataset stored in the filetype Geopackage (similar to shapefile)
# there are 975 polygons with fruit types
# there are 44 different fruit-types (levels)

##########################################################
# Task 2: Annotate Trajectories from vector data

# Filter the months may to june
wildschwein_filter <- wildschwein %>%
  mutate(Monat = month(DatetimeUTC)) %>%
  filter(Monat == 5 | Monat == 6)

# Overlap wildschwein_filter with feldaufnahmen





