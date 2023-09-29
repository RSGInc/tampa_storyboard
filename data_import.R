# TAMPA Mobility Dashboard. Data Import.R
# Developed by Kyeongsu Kim and Reid Haefer at RSG
# latest update: 09-28-2023 11:28 by Kyeongsu Kim; 
#  - fixed the deploying error issue caused by spatial dataframe CRS consistency issue,
#  -- make sure to apply st_crs for reading files by sf packages or binary file formatted by sf package. 
#  -- for file read by 'sp' package or 'geojsonio' needs to apply "st_as_sf(crs=4326)", not st_crs
#  -- as an alternative, use 'geojsonsf' package, and use geojson_sf and apply st_crs.
#  - add original package name before a function. e.g:: geojsonio::geojson_read


source(file.path("config_variables.R"))

#R package required 
SYSTEM_PKGS <- c("tidyverse", "data.table", "leaflet", "plotly", "tigris", "sf", "sfarrow", "arrow" , 'shiny',
                 'shinyjs', 'shinyalert', 'shinycssloaders', 'shinydashboard', 'shinyWidgets', 'shinyFiles',
                 'htmltools', 'htmlwidgets', 'geojsonio', 'mapview', 'RColorBrewer', 'scales', 'Rfast', 'DT', 
                 'BAMMtools', 'reactable', 'reactablefmtr', 'purrr', 'readxl', 'mltools', 'formattable', 'geojsonsf')

invisible(lapply(SYSTEM_PKGS, require, character.only = TRUE))    # Load multiple packages

options(scipen=999)
options(digits = 6)
options(tigris_use_cache = TRUE)
# options(shiny.maxRequestSize=30*1024^2)

# 0. Read GIS County Place, TAZ and BG geospatial data ----------
gis_CPlace  = readRDS(file.path(APP_INPUT_GIS_DATA_PATH, "gis_CPlace.rds"))
st_crs(gis_CPlace) = 4326
gis_TAZ     = readRDS(file.path(APP_INPUT_GIS_DATA_PATH, "gis_TAZ.rds")) %>% st_transform(4326)
gis_TAZ     = gis_TAZ[, c("ZONE", "COUNTY", "geom")]; names(gis_TAZ) = tolower(names(gis_TAZ)) 
gis_BG      = readRDS(file.path(APP_INPUT_GIS_DATA_PATH, "gis_BG.rds")) %>% st_transform(4326)
gis_POI     = readRDS(file.path(APP_INPUT_GIS_DATA_PATH, "gis_POI.rds")) %>% st_transform(4326)
gis_cengeo19  = readRDS(file.path(APP_INPUT_GIS_DATA_PATH, APP_INPUT_OD_TOTAL_GIS_DATA_NAME_2019))
gis_cengeo22  = readRDS(file.path(APP_INPUT_GIS_DATA_PATH, APP_INPUT_OD_TOTAL_GIS_DATA_NAME_2022))
st_crs(gis_cengeo19) = 4326; st_crs(gis_cengeo22) = 4326
st_crs(gis_BG)  = 4326; st_crs(gis_TAZ)  = 4326; st_crs(gis_POI)  = 4326

# to get lat/lon for zoom-in set in 10.poi
lon = map_dbl(gis_POI$geom, ~st_point_on_surface(.x)[[1]])
lat = map_dbl(gis_POI$geom, ~st_point_on_surface(.x)[[2]])
# gis_POI$POI_Description[gis_POI$POI_Description == "Tropicana Stadium"] = "Tropicana Field"
poi_name = gis_POI$POI_Description
poi_latlon = data.frame(poi_name, lon, lat); rm(lon, lat, poi_name)

## POI flows to be merged with o_and_d_tatals tables -----------
gis_d7_edge19 = readRDS(file.path(APP_INPUT_GIS_DATA_PATH, APP_INPUT_NETWORK_D7_EDGES_DATA_NAME_2019))
gis_d7_edge22 = readRDS(file.path(APP_INPUT_GIS_DATA_PATH, APP_INPUT_NETWORK_D7_EDGES_DATA_NAME_2022))

APP_INPUT_DATA_DIR_NAME = "data"
APP_INPUT_DATA_PATH     = file.path(SYSTEM_APP_PATH, APP_INPUT_DATA_DIR_NAME)

APP_INPUT_GIS_DATA_DIR_NAME = "data/gis"
APP_INPUT_GIS_DATA_PATH     = file.path(SYSTEM_APP_PATH, APP_INPUT_GIS_DATA_DIR_NAME)

APP_INPUT_SPEND_DATA_DIR_NAME = "data/spending"
APP_INPUT_SPEND_DATA_PATH     = file.path(SYSTEM_APP_PATH, APP_INPUT_SPEND_DATA_DIR_NAME)

APP_INPUT_TRIP_CHAR_DATA_DIR_NAME = "data/trip_characteristics"
APP_INPUT_TRIP_CHAR_DATA_PATH     = file.path(SYSTEM_APP_PATH, APP_INPUT_TRIP_CHAR_DATA_DIR_NAME)


# 1. Read Input Data ---------
## 1.2 for O-D Comparison Tab: od_tables (from Replica data) -------
# APP_INPUT_OD_TOTAL_DATA  = readRDS(file.path(APP_INPUT_OD_REPLICA_DATA_PATH, APP_INPUT_OD_REPLICA_DATA_NAME))
APP_INPUT_REPLICA_OD_DATA_2022 = readRDS(file.path(APP_INPUT_REPLICA_OD_DATA_PATH, APP_INPUT_REPLICA_OD_DATA_NAME_2022))
APP_INPUT_REPLICA_OD_COLORPAL_2022 = readRDS(file.path(APP_INPUT_REPLICA_OD_DATA_PATH, APP_INPUT_REPLICA_OD_COLORPAL_NAME_2022))
APP_INPUT_RMERGE_OD_DATA_2019  = readRDS(file.path(APP_INPUT_RMERGE_OD_DATA_PATH, APP_INPUT_RMERGE_OD_DATA_NAME_2019))

# year_choices = parse_number(names(APP_INPUT_OD_REPLICA_DATA_LIST))
# od_market_type = unique(APP_INPUT_OD_REPLICA_DATA_2019[["market"]])

## POI OD rds files processing ---------
APP_POI_OD_TABLE_2019  = lapply(file.path(APP_INPUT_OD_TOTAL_DATA_PATH, APP_INPUT_OD_TOTAL_DATA_NAME_2019), readRDS)[[1]]
APP_POI_OD_TABLE_2022  = lapply(file.path(APP_INPUT_OD_TOTAL_DATA_PATH, APP_INPUT_OD_TOTAL_DATA_NAME_2022), readRDS)[[1]]
# gis_APP_POI_OD_TABLE_2019 = merge(gis_cengeo19, APP_POI_OD_TABLE_2019[[1]][[1]], by = 'GEOID')
# names(APP_POI_OD_TABLE_2019); names(APP_POI_OD_TABLE_2022)
## POI LINK FLOWS rds files into list ---------
APP_POI_OD_LINK_FLOWS_2019   <- lapply(file.path(APP_INPUT_LINK_FLOWS_DATA_PATH, APP_INPUT_LINK_FLOWS_DATA_NAME_2019), readRDS)[[1]]
APP_POI_OD_LINK_FLOWS_2022   <- lapply(file.path(APP_INPUT_LINK_FLOWS_DATA_PATH, APP_INPUT_LINK_FLOWS_DATA_NAME_2022), readRDS)[[1]]
APP_POI_OD_LINK_FLOWS_BINS_LIST <- readRDS(file.path(APP_INPUT_LINK_FLOWS_DATA_PATH, APP_INPUT_LINK_FLOWS_BIN_LIST_NAME))

# read trip characteristics rds files into list ---------
APP_INPUT_TRIP_CATEGORY_LIST       <- list.files(APP_INPUT_TRIP_CHAR_DATA_PATH, pattern='trip_category') 
APP_INPUT_TRIP_CATEGORY_FILELIST   <- lapply(file.path(APP_INPUT_TRIP_CHAR_DATA_PATH, APP_INPUT_TRIP_CATEGORY_LIST), readRDS)
names(APP_INPUT_TRIP_CATEGORY_FILELIST) <- gsub(".rds","",APP_INPUT_TRIP_CATEGORY_LIST)

APP_INPUT_TRIP_DISTANCE_LIST       <- list.files(APP_INPUT_TRIP_CHAR_DATA_PATH, pattern='trip_distance') 
APP_INPUT_TRIP_DISTANCE_FILELIST   <- lapply(file.path(APP_INPUT_TRIP_CHAR_DATA_PATH, APP_INPUT_TRIP_DISTANCE_LIST), readRDS)
names(APP_INPUT_TRIP_DISTANCE_FILELIST) <- gsub(".rds","",APP_INPUT_TRIP_DISTANCE_LIST)

APP_INPUT_TRIP_InOut_D7_LIST       <- list.files(APP_INPUT_TRIP_CHAR_DATA_PATH, pattern='trip_in_out_d7') 
APP_INPUT_TRIP_InOut_D7_FILELIST   <- lapply(file.path(APP_INPUT_TRIP_CHAR_DATA_PATH, APP_INPUT_TRIP_InOut_D7_LIST), readRDS)
names(APP_INPUT_TRIP_InOut_D7_FILELIST) <- gsub(".rds","",APP_INPUT_TRIP_InOut_D7_LIST)

APP_INPUT_TRIP_PURPOSE_LIST       <- list.files(APP_INPUT_TRIP_CHAR_DATA_PATH, pattern='trip_purpose') 
APP_INPUT_TRIP_PURPOSE_FILELIST   <- lapply(file.path(APP_INPUT_TRIP_CHAR_DATA_PATH, APP_INPUT_TRIP_PURPOSE_LIST), readRDS)
names(APP_INPUT_TRIP_PURPOSE_FILELIST) <- gsub(".rds","",APP_INPUT_TRIP_PURPOSE_LIST)

APP_INPUT_TRIP_TOD_LIST       <- list.files(APP_INPUT_TRIP_CHAR_DATA_PATH, pattern='trip_tod') 
APP_INPUT_TRIP_TOD_FILELIST   <- lapply(file.path(APP_INPUT_TRIP_CHAR_DATA_PATH, APP_INPUT_TRIP_TOD_LIST), readRDS)
names(APP_INPUT_TRIP_TOD_FILELIST) <- gsub(".rds","",APP_INPUT_TRIP_TOD_LIST)


APP_INPUT_TRIP_CHARACTERISTIC_FILELIST   <- readRDS(file.path(APP_INPUT_TRIP_CHAR_DATA_PATH, APP_INPUT_TRIP_CHAR_DATA_NAME1))
# names(APP_INPUT_TRIP_CHARACTERISTIC_FILELIST)
vmt_per_capita_2019 = APP_INPUT_TRIP_CHARACTERISTIC_FILELIST[names(APP_INPUT_TRIP_CHARACTERISTIC_FILELIST) %in% "vmt_per_capita_2019"][[1]]
vmt_per_capita_2022 = APP_INPUT_TRIP_CHARACTERISTIC_FILELIST[names(APP_INPUT_TRIP_CHARACTERISTIC_FILELIST) %in% "vmt_per_capita_2022"][[1]]

# zone_choices[which(zone_choices %in% "Tropicana Stadium")] = "Tropicana Field"



# #### Reid import ####

# spend data ----------
spend_tract  = readRDS(file.path("data/reid_data/spending/spend_tract.rds"))
spend_county = readRDS(file.path("data/reid_data/spending/spend_county.rds"))

county_point = geojsonsf::geojson_sf("data/gis/county_point.geojson")
states_point = geojsonsf::geojson_sf("data/gis/states_point.geojson")
tracts_point = geojsonsf::geojson_sf("data/gis/tracts_point.geojson")
st_crs(county_point) = 4326; st_crs(states_point) = 4326; st_crs(tracts_point) = 4326; 


#county= geojsonsf::geojson_sf(file.path(APP_INPUT_GIS_DATA_PATH, "county.geojson"))
# county_point= geojsonsf::geojson_sf(file.path(APP_INPUT_GIS_DATA_PATH, "county_point.geojson"))
gis_state   = geojsonsf::geojson_sf(file.path(APP_INPUT_GIS_DATA_PATH, "states.geojson"))
tract_spend_point   = geojsonsf::geojson_sf(file.path(APP_INPUT_GIS_DATA_PATH, "tract_spend_point.geojson"))
st_crs(gis_state) = 4326; st_crs(tract_spend_point) = 4326;
# sf::sf_use_s2(FALSE)
# gis_d7   = geojsonsf::geojson_sf(file.path("data/gis/d7_study_boundary.geojson")) %>%
#   summarise() %>% mutate(d7="yes") %>%
#   mutate(POI_ID="D7", POI_Description="D7") %>%
#   select(POI_ID,POI_Description)

gis_d7   = geojsonsf::geojson_sf(file.path("data/gis/d7_study_boundary.geojson"))
st_crs(gis_d7) = 4326
gis_d7 = gis_d7 %>%
  mutate(d7="yes") %>%
  mutate(POI_ID="D7", POI_Description="D7") %>%
  select(POI_ID,POI_Description)

gis_POI_D7 <- bind_rows(
  gis_POI %>% mutate(POI_ID=as.character(POI_ID)) %>% select(POI_ID,POI_Description),
  gis_d7 %>% rename(geom=geometry)
)



#tracts = geojsonsf::geojson_sf(file.path(APP_INPUT_GIS_DATA_PATH, "tracts_FL.geojson")) 

vis_lbs_home_d7_state_df <- arrow::read_parquet("data/reid_data/vis_lbs_home_d7_state_df.parquet")
vis_lbs_home_state<- readRDS("data/reid_data/vis_lbs_home_state.rds")

#lu<- arrow::arrow::read_parquet("data/reid_data/land_use.parquet")

#vis_bg_sf<- readRDS("data/reid_data/vis_bg_sf.rds")

#vis_replica_clean<- arrow::read_parquet("data/reid_data/vis_replica_clean.parquet") 

#service_pop<- arrow::read_parquet("data/reid_data/service_pop.parquet")

#commercial vehicles
tod_all<- arrow::read_parquet("data/reid_data/tod_all.parquet")
trip_all<- arrow::read_parquet("data/reid_data/trip_all.parquet")

#geo data
com_veh_geo<- bind_rows(
  county_point %>% select(GEOID) %>% mutate(type='county') %>% filter(GEOID %in% unique(trip_all$geo)),
  states_point %>% select(GEOID)  %>% mutate(type='state') %>% filter(GEOID %in% unique(trip_all$geo)),
  tracts_point %>% select(GEOID)  %>% mutate(type='tract') %>% filter(GEOID %in% unique(trip_all$geo))
)

## resident home location

res_data <- arrow::read_parquet("data/reid_data/res_loc_attributes.parquet")%>%
  mutate(poi_name=case_when(is.na(poi_name) ~ "D7", TRUE ~ as.character(poi_name)))

res_work_loc<- arrow::read_parquet("data/reid_data/res_work_locations.parquet") %>%
  mutate(poi_name=case_when(is.na(poi_name) ~ "D7", TRUE ~ as.character(poi_name)))

############

### employee location

worker_data <- arrow::read_parquet("data/reid_data/worker_loc_attributes.parquet")%>%
  mutate(poi_name=case_when(is.na(poi_name) ~ "D7", TRUE ~ as.character(poi_name)))

worker_home_loc<-arrow::read_parquet("data/reid_data/worker_home_locations.parquet")%>%
  mutate(poi_name=case_when(is.na(poi_name) ~ "D7", TRUE ~ as.character(poi_name)))


## visitor location

vis_attributes <-arrow::read_parquet("data/reid_data/vis_loc_attributes.parquet")
vis_home_loc_df<-arrow::read_parquet("data/reid_data/vis_home_loc_df.parquet")

################

# zone_choices_ori = zone_choices
# zone_choices[which(zone_choices %in% "Tropicana Stadium")] = "Tropicana Field"
# 
# zone_poi_choices = POI_df[["POI_ID"]]
# 
# st_transform(gis_POI, 4326)
# gis_POI$lat = NA
# gis_POI$long = NA
# gis_POI$zoom = NA
# 
# for(i in 1:10){
#   gis_POI$lat[i]  = mean(gis_POI[[4]][[i]][[1]][[1]][,2])
#   gis_POI$long[i] = mean(gis_POI[[4]][[i]][[1]][[1]][,1])
#   gis_POI$zoom[i] = 11
# }


### COVID

covid_wfh<-readxl::read_excel("data/reid_data/Tampa_Survey_Report_Storyboard_Mockup_v2.xlsx", sheet="covid_wfh")
covid_wfh2<-readxl::read_excel("data/reid_data/Tampa_Survey_Report_Storyboard_Mockup_v2.xlsx", sheet="covid_wfh2")
covid_pop<-readxl::read_excel("data/reid_data/Tampa_Survey_Report_Storyboard_Mockup_v2.xlsx", sheet="covid_pop")
covid_transit<-readxl::read_excel("data/reid_data/Tampa_Survey_Report_Storyboard_Mockup_v2.xlsx", sheet="covid_transit")
covid_vis<-readxl::read_excel("data/reid_data/Tampa_Survey_Report_Storyboard_Mockup_v2.xlsx", sheet="covid_vis_est")

### service population

serv_pop_lu <- arrow::read_parquet("data/reid_data/serv_pop_lu.parquet") %>%
  mutate(POI=case_when(POI %in% c("Florida District 7","Florida") ~ "D7", 
                       POI %in% c("Crystal River") ~ "Crystal River Wildlife Areas", 
                       TRUE ~ as.character(POI)))

## land use
lu<- arrow::read_parquet("data/reid_data/land_use.parquet")

