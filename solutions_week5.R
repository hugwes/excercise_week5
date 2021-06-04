
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
library(tmap)

# Import data
wildschwein <- read_delim("wildschwein_BE_2056.csv",",") %>%
  st_as_sf(coords = c("E", "N"), crs = 2056, remove = FALSE)

##########################################################
# Task 1: Import and visualize spatial data

# Import
feldaufnahmen <- read_sf("Feldaufnahmen_Fanel.gpkg")

# Overview
head(feldaufnahmen)
summary(feldaufnahmen)
unique(feldaufnahmen$Frucht)
st_crs(feldaufnahmen)

# Plot
ggplot(feldaufnahmen) +
  geom_sf(aes(fill = Frucht))

##########################################################
# Task 2: Annotate Trajectories from vector data

# Filter the months may to june (Wesley)
wildschwein_filter <- wildschwein %>%
  mutate(Monat = month(DatetimeUTC)) %>%
  filter(Monat == 5 | Monat == 6)

# Filter the months may to june (Solutions)
wildschwein_summer <- wildschwein %>%
  filter(month(DatetimeUTC) %in% 5:6)

# Join with Feldaufnahmen
wildschwein_join <-  st_join(wildschwein_summer, feldaufnahmen)

# Plot
ggplot(feldaufnahmen) +
  geom_sf(aes(fill = Frucht)) +
  geom_sf(data = wildschwein_summer)

##########################################################
# Task 3: Explore annotated trajectories (Wesley)

# Gruppieren, Agregieren, 
wildschwein_sum <- wildschwein_join %>%
  mutate(Stunde = hour(DatetimeUTC)) %>%
  group_by(TierName, Stunde, Frucht) %>%
  summarise(n=n()) %>%
  group_by(TierName, Stunde) %>%
  mutate(n_tot= sum(n), sum_rel = n/n_tot)

# Plot 1
ggplot(wildschwein_sum, aes(Stunde, n, fill=Frucht)) +
  geom_col() + 
  facet_wrap(~TierName)

# Plot 2 
ggplot(wildschwein_sum, aes(Stunde, sum_rel, fill=Frucht)) +
  geom_col() + 
  facet_wrap(~TierName)
  
##########################################################
# Task 3: Explore annotated trajectories (Solutions)
library(forcats)

wildschwein_smry <- wildschwein_join %>%
  st_set_geometry(NULL) %>%
  mutate(
    hour = hour(round_date(DatetimeUTC,"hour")),
    Frucht = ifelse(is.na(Frucht),"other",Frucht),
    Frucht = fct_lump(Frucht, 5,other_level = "other"),
  ) %>%
  group_by(TierName ,hour,Frucht) %>%
  count() %>%
  ungroup() %>%
  group_by(TierName , hour) %>%
  mutate(perc = n / sum(n)) %>%
  ungroup() %>%
  mutate(
    Frucht = fct_reorder(Frucht, n,sum, desc = TRUE))

# Plot 1
p1 <- ggplot(wildschwein_smry, aes(hour,perc, fill = Frucht)) +
  geom_col(width = 1) +
  scale_y_continuous(name = "Percentage", labels = scales::percent_format()) +
  scale_x_continuous(name = "Time (rounded to the nearest hour)") +
  facet_wrap(~TierName ) +
  theme_light() +
  labs(title = "Percentages of samples in a given crop per hour",subtitle = "Only showing the most common categories")

p1

# Plot 2
p1 +
  coord_polar()  +
  labs(caption = "Same visualization as above, displayed in a polar plot")

##########################################################
# Task 4: Import and visualize vegetationindex (raster data)

# Import
vegetationshoehe <- terra::rast("vegetationshoehe_LFI.tif")

# Plot
tm_shape(vegetationshoehe) + 
  tm_raster(palette = "viridis",style = "cont", legend.is.portrait = FALSE) +
  tm_layout(legend.outside = TRUE,legend.outside.position = "bottom", frame = FALSE)

##########################################################
# Task 5: Annotate Trajectories from raster data

# Extract (terra)
vegetationshoehe_df <- terra::extract(vegetationshoehe, st_coordinates(wildschwein))

# C-bind
w <- cbind(wildschwein, vegetationshoehe_df)



