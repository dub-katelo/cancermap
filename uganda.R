# Load necessary libraries
library(leaflet)
library(sf)
library(dplyr)
library(htmlwidgets)

# Generate sample data for leukemia patients in Uganda
set.seed(123)  # For reproducibility
uganda_patients <- data.frame(
  longitude = runif(100, min = 29.5, max = 35.0),  # Approximate longitude range for Uganda
  latitude = runif(100, min = -1.5, max = 4.0),    # Approximate latitude range for Uganda
  intensity = runif(100, min = 1, max = 10)  # Represents number of patients
)

# Convert to a spatial data frame
uganda_patients_sf <- st_as_sf(uganda_patients, coords = c("longitude", "latitude"), crs = 4326)

# Define a color palette function based on intensity
pal <- colorNumeric(palette = "Purples", domain = uganda_patients_sf$intensity)

# Create the leaflet map
uganda_map <- leaflet(data = uganda_patients_sf) %>%
  addTiles() %>%
  addCircleMarkers(
    radius = ~sqrt(intensity) * 3,  # Adjust the radius for better visualization
    color = ~pal(intensity),
    fillOpacity = 0.5,
    stroke = FALSE,
    label = ~paste("Patients:", intensity)
  ) %>%
  addLegend(
    position = "bottomright",
    pal = pal,
    values = ~intensity,
    title = "Intensity of Leukemia Cases",
    opacity = 1
  )

# Display the map
uganda_map

# Save the map to an HTML file
saveWidget(uganda_map, file = "uganda_leukemia_heatmap.html", selfcontained = TRUE)
