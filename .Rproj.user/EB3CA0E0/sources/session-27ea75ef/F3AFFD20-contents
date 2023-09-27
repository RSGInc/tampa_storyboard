# TAMPA Mobility Dashboard Config_System_Path.R
# Only for pre-data processing (do not include with source function)
# Developed by Kyeongsu Kim &  Reid Haefer at RSG
# latest update: 08-12-2023 15:09 by Kyeongsu Kim

rm(list=ls())

#R package required 
SYSTEM_PKGS <- c("tidyverse", "data.table", "leaflet", "plotly", "tigris", "sf", "sfarrow", "arrow" , 'shiny',
                 'shinyjs', 'shinyalert', 'shinycssloaders', 'shinydashboard', 'shinyWidgets', 'shinyFiles',
                 'htmltools', 'htmlwidgets', 'geojsonio', 'mapview', 'RColorBrewer', 'scales', 'Rfast', 'DT', 
                 'BAMMtools', 'reactable', 'reactablefmtr', 'purrr', 'readxl', 'mltools', 'DT', 'formattable')

new.packages <- SYSTEM_PKGS[!(SYSTEM_PKGS %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

SYSTEM_APP_PATH = getwd()

# install if new package is added
lapply(SYSTEM_PKGS, require, character.only = TRUE)    # Load multiple packages

user = Sys.info()['user']; user
TAMPA_VIS_AUG_PATH = file.path("C:/Users", user, "OneDrive - Resource Systems Group, Inc", "Tampa Replica Visitor Survey Augment")

# data year and quarter (for replica)
YEAR_NAME = "2022"; QTR_NAME  = "Q4"; YR_QTR_NAME = paste0(YEAR_NAME, " ", QTR_NAME)

palette_color1      = "RdYlBu"
palette_color2      = "RdYlGn"
palette_color3      = "Orange"
palette_color4      = "Purples"


# app input data file names --------
APP_INPUT_TRIP_CHAR_DATA_NAME1 = "trip_characteristics1_2019_2022.rds"
APP_INPUT_TRIP_CHAR_DATA_NAME2 = "trip_characteristics2_2019_2022.rds"
APP_INPUT_OD_TOTAL_DATA_NAME_2019     = "o_and_d_totals_2019.rds"
APP_INPUT_OD_TOTAL_DATA_NAME_2022     = "o_and_d_totals_2022.rds"
APP_INPUT_OD_TOTAL_GIS_DATA_NAME_2019 = "census_geos_2019.rds"
APP_INPUT_OD_TOTAL_GIS_DATA_NAME_2022 = "census_geos_2022.rds"
APP_INPUT_LINK_FLOWS_DATA_NAME_2019 = "link_flows_2019.rds"
APP_INPUT_LINK_FLOWS_DATA_NAME_2022 = "link_flows_2022.rds"
APP_INPUT_LINK_FLOWS_BIN_LIST_NAME = "poi_od_flows_bins.rds"
APP_INPUT_NETWORK_D7_EDGES_DATA_NAME_2019 = "2019_d7_edges.rds"
APP_INPUT_NETWORK_D7_EDGES_DATA_NAME_2022 = "2022_d7_edges.rds"
APP_INPUT_REPLICA_OD_DATA_NAME_2022 = "od_tables_2022.rds"
APP_INPUT_REPLICA_OD_COLORPAL_NAME_2022 = "od_tables_2022_colorpal.rds"
APP_INPUT_REPLICA_OD_DATA_LONG_NAME = "od_tables_long_2022.rds"
APP_INPUT_RMERGE_OD_DATA_NAME_2019 = "rmerge_od_2019.rds"

# app data directory -------
APP_INPUT_DATA_DIR_NAME = "data"
APP_INPUT_DATA_PATH     = file.path(SYSTEM_APP_PATH, APP_INPUT_DATA_DIR_NAME)
dir.create(APP_INPUT_DATA_PATH, showWarnings = FALSE)

## app gis data directory -------
APP_INPUT_GIS_DATA_DIR_NAME = "data/gis"
APP_INPUT_GIS_DATA_PATH     = file.path(SYSTEM_APP_PATH, APP_INPUT_GIS_DATA_DIR_NAME)
dir.create(APP_INPUT_GIS_DATA_PATH, showWarnings = FALSE)

## app spending data directory --------
APP_INPUT_SPEND_DATA_DIR_NAME = "data/spending"
APP_INPUT_SPEND_DATA_PATH     = file.path(SYSTEM_APP_PATH, APP_INPUT_SPEND_DATA_DIR_NAME)
dir.create(APP_INPUT_SPEND_DATA_PATH, showWarnings = FALSE)

## app trip_characteristics data directory --------
APP_INPUT_TRIP_CHAR_DATA_DIR_NAME = "data/trip_characteristics"
APP_INPUT_TRIP_CHAR_DATA_PATH     = file.path(SYSTEM_APP_PATH, APP_INPUT_TRIP_CHAR_DATA_DIR_NAME)
dir.create(APP_INPUT_TRIP_CHAR_DATA_PATH, showWarnings = FALSE)

RMERGE_DIR_NAME = "previous_rsg_expanded_lbs"
APP_INPUT_RMERGE_OD_DATA_DIR_NAME = "data/previous_rsg_expanded_lbs"
APP_INPUT_RMERGE_OD_DATA_PATH     = file.path(SYSTEM_APP_PATH, APP_INPUT_RMERGE_OD_DATA_DIR_NAME)
dir.create(APP_INPUT_RMERGE_OD_DATA_PATH, showWarnings = FALSE)


## app o_and_d_totals directory ------------
OUTPUTS_OD_TOTAL_DIR_NAME  = "o_and_d_totals"
APP_INPUT_OD_TOTAL_DATA_PATH =  file.path(APP_INPUT_DATA_PATH, OUTPUTS_OD_TOTAL_DIR_NAME)
APP_INPUT_OD_TOTAL_DATA_PATH_2019 =  file.path(APP_INPUT_OD_TOTAL_DATA_PATH,"2019/weekday")
APP_INPUT_OD_TOTAL_DATA_PATH_2022 =  file.path(APP_INPUT_OD_TOTAL_DATA_PATH,"2022/weekday")
dir.create(file.path(APP_INPUT_DATA_PATH, OUTPUTS_OD_TOTAL_DIR_NAME), showWarnings = FALSE)
dir.create(file.path(APP_INPUT_DATA_PATH, OUTPUTS_OD_TOTAL_DIR_NAME, "2019"), showWarnings = FALSE)
dir.create(file.path(APP_INPUT_DATA_PATH, OUTPUTS_OD_TOTAL_DIR_NAME, "2022"), showWarnings = FALSE)
dir.create(APP_INPUT_OD_TOTAL_DATA_PATH_2019, showWarnings = FALSE)
dir.create(APP_INPUT_OD_TOTAL_DATA_PATH_2022, showWarnings = FALSE)

## app od_table directory ------------
OUTPUTS_REPLICA_OD_DIR_NAME  = "od_tables"
APP_INPUT_REPLICA_OD_DATA_PATH =  file.path(APP_INPUT_DATA_PATH, OUTPUTS_REPLICA_OD_DIR_NAME)
dir.create(APP_INPUT_REPLICA_OD_DATA_PATH, showWarnings = FALSE)

## app link_flows directory ------------
OUTPUTS_LINK_FLOWS_DIR_NAME  = "link_flows"
APP_INPUT_LINK_FLOWS_DATA_PATH =  file.path(APP_INPUT_DATA_PATH, OUTPUTS_LINK_FLOWS_DIR_NAME)
APP_INPUT_LINK_FLOWS_DATA_PATH_2019 =  file.path(APP_INPUT_LINK_FLOWS_DATA_PATH,"2019/weekday")
APP_INPUT_LINK_FLOWS_DATA_PATH_2022 =  file.path(APP_INPUT_LINK_FLOWS_DATA_PATH,"2022/weekday")
dir.create(file.path(APP_INPUT_DATA_PATH, OUTPUTS_LINK_FLOWS_DIR_NAME), showWarnings = FALSE)
dir.create(file.path(APP_INPUT_DATA_PATH, OUTPUTS_LINK_FLOWS_DIR_NAME, "2019"), showWarnings = FALSE)
dir.create(file.path(APP_INPUT_DATA_PATH, OUTPUTS_LINK_FLOWS_DIR_NAME, "2022"), showWarnings = FALSE)
dir.create(APP_INPUT_LINK_FLOWS_DATA_PATH_2019, showWarnings = FALSE)
dir.create(APP_INPUT_LINK_FLOWS_DATA_PATH_2022, showWarnings = FALSE)

# sharepoint (original) data path ------------
## geometry_dev_data ------------
DEV_DATA_DIR_NAME = "dev_data"
DEV_DATA_REPLICA_NAME = "replica"
TRIPCHARACTERISTICS_NAME = "trip_characteristics"

SPENDING_TREND_DIR_NAME = "spending trend"
SPEND_COUNTY_FILE_NAME = "spend_by_merchant_county_fullweek.csv"
SPEND_TRACK_FILE_NAME  = "spend_by_merchant_tract_fullweek.csv"

## trip characteristics ------------
SPEND_COUNTY_FILE_NAME = "spend_by_merchant_county_fullweek.csv"
SPEND_TRACK_FILE_NAME  = "spend_by_merchant_tract_fullweek.csv"

## geometry_study area ------------
STUDYAREA_DIR_NAME = "Geometry/Study Area"
STUDYAREA_CPLACE_FILE_NAME = "census_place.parquet"
STUDYAREA_TAZ_FILE_NAME = "Model_TAZ.gpkg"
STUDYAREA_BG_FILE_NAME  = "Study area BG from Replica.gpkg"

## geometry_POI ------------
POI_DIR_NAME   = "Geometry/POI"
POI_FILE_NAME  = "pois.gpkg"

INPUT_REPLICA_COUNTY_PATH     = file.path(TAMPA_VIS_AUG_PATH, DEV_DATA_DIR_NAME, DEV_DATA_REPLICA_NAME, SPENDING_TREND_DIR_NAME, YR_QTR_NAME, SPEND_COUNTY_FILE_NAME)
INPUT_REPLICA_TRACK_PATH      = file.path(TAMPA_VIS_AUG_PATH, DEV_DATA_DIR_NAME, DEV_DATA_REPLICA_NAME, SPENDING_TREND_DIR_NAME, YR_QTR_NAME, SPEND_TRACK_FILE_NAME)
INPUT_STUDYAREA_CPLACE_PATH   = file.path(TAMPA_VIS_AUG_PATH, STUDYAREA_DIR_NAME, STUDYAREA_CPLACE_FILE_NAME)
INPUT_STUDYAREA_TAZ_PATH      = file.path(TAMPA_VIS_AUG_PATH, STUDYAREA_DIR_NAME, STUDYAREA_TAZ_FILE_NAME)
INPUT_STUDYAREA_BG_PATH       = file.path(TAMPA_VIS_AUG_PATH, STUDYAREA_DIR_NAME, STUDYAREA_BG_FILE_NAME)
INPUT_POI_PATH                = file.path(TAMPA_VIS_AUG_PATH, POI_DIR_NAME, POI_FILE_NAME)

## geometry_network ------------
NEWTORK_DIR_NAME   = "Geometry/network"
INPUT_NETWORK_PATH       = file.path(TAMPA_VIS_AUG_PATH, NEWTORK_DIR_NAME)
INPUT_NETWORK_D7_EDGES_PATH_2019  = file.path(INPUT_NETWORK_PATH, "2019_d7_edges.parquet")
INPUT_NETWORK_D7_EDGES_PATH_2022  = file.path(INPUT_NETWORK_PATH, "2022_d7_edges.parquet")


INPUT_NETWORK_PATH_DIR_2019  = file.path(INPUT_NETWORK_PATH, "2019")
INPUT_NETWORK_PATH_DIR_2022  = file.path(INPUT_NETWORK_PATH, "2022")
INPUT_NETWORK_PATH_DIR_2019_COUNTIES = list.files(INPUT_NETWORK_PATH_DIR_2019)
INPUT_NETWORK_PATH_DIR_2022_COUNTIES = list.files(INPUT_NETWORK_PATH_DIR_2022)

# outputs\ -------
OUTPUTS_DIR_NAME = "outputs"

## outputs\link_flows-----------
INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH = file.path(TAMPA_VIS_AUG_PATH, OUTPUTS_DIR_NAME, OUTPUTS_LINK_FLOWS_DIR_NAME)
INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH_2019 = file.path(INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH, "2019/weekday")
INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH_2022 = file.path(INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH, "2022/weekday")

## outputs\o_and_d_totals ------------
INPUT_OUTPUTS_OD_TOTAL_DATA_PATH = file.path(TAMPA_VIS_AUG_PATH, OUTPUTS_DIR_NAME, OUTPUTS_OD_TOTAL_DIR_NAME)
INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2019 = file.path(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH, "2019/weekday")
INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2022 = file.path(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH, "2022/weekday")

INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2019_GIS_PATH = file.path(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH, "2019/weekday/census_geos_2019.parquet")
INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2022_GIS_PATH = file.path(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH, "2022/weekday/census_geos_2022.parquet")

## app od_table directory ------------
OUTPUTS_REPLICA_OD_DIR_NAME  = "od_tables"
INPUT_OUTPUTS_REPLICA_OD_DATA_PATH = file.path(TAMPA_VIS_AUG_PATH, OUTPUTS_DIR_NAME, OUTPUTS_REPLICA_OD_DIR_NAME)

## outputs\trip_characteristics ------------
INPUT_OUTPUTS_TRIP_CHAR_PATH          = file.path(TAMPA_VIS_AUG_PATH, OUTPUTS_DIR_NAME, TRIPCHARACTERISTICS_NAME)
INPUT_OUTPUTS_TRIP_CHAR_PATH_2019     = file.path(INPUT_OUTPUTS_TRIP_CHAR_PATH, "2019/weekday")
INPUT_OUTPUTS_TRIP_CHAR_PATH_2022     = file.path(INPUT_OUTPUTS_TRIP_CHAR_PATH, "2022/weekday")

# previous_rsg_expanded_lbs\..........
## previous_rsg_expanded_lbs\od-----------
INPUT_RMERGE_DATA_PATH = file.path(TAMPA_VIS_AUG_PATH, RMERGE_DIR_NAME)
INPUT_RMERGE_DATA_PATH_INTERNAL_OD_PATH = file.path(INPUT_RMERGE_DATA_PATH, "TBRTS-Internal_OD_Tables_20200414.parquet")
INPUT_RMERGE_DATA_PATH_EXTERNAL_OD_PATH = file.path(INPUT_RMERGE_DATA_PATH, "TBRTS-External_OD_Tables_20200414.parquet")


