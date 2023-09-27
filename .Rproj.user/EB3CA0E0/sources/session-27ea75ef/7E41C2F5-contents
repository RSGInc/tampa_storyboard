# TAMPA Mobility Dashboard. Config_Variables.R
# Developed by Kyeongsu Kim, Reid Haefer, Matt Landis at RSG

# source(file.path(getwd(), "data_import.R"))

app_name = "TAMPA_MOBILTY"
app_version = "2023-1"

# for ui_3_Storyboard.R

zone_display_choices         = c("Zone Comparison","Zone of Interest Data Only")
time_period_choices          = c("AM","PM")
day_choices                  = c("Monday","Tuesday","Wednesday")
traveler_type_choices        = c("Resident","Visitor","Employee")
mode_choices                 = c("Auto","Walk","Transit")

zone_choices_list = c("Busch Gardens" = 1, "Clearwater Beach" = 2 , "Crystal River Wildlife Areas" = 3, "Downtown St Petersburg" = 4, "Downtown Tampa" = 5, "Hernando Beach" = 6, 
                      "Port Tampa Bay Cruise Terminals and Florida Aquarium" = 7, "Raymond James Stadium" = 8 , "Tropicana Field" = 9, "Weekiwachee Gardens and Wildlife Areas" = 10)
interest_zone_choices = zone_choices = names(zone_choices_list)


vis_zone_choices = lu_zone_choices = trip_zone_choices = od_zone_choices = poi_zone_choices  = zone_choices
# poi_zone_choices = c("District 7", poi_zone_choices)
trip_year_choices = od_year_choices = poi_year_choices= c(2019, 2022)
trip_purpose_choices         = c("Home-Based Other", "Home-Based Work", "NonHome-Based Other", "NonHome-Based Work")
trip_purpose_choices_list    = c("Home-Based Other" = "hbo", "Home-Based Work" = "hbw", "NonHome-Based Other" = "nhbo", "NonHome-Based Work" = "nhbw")
trip_purpose_choices_short   = c("hbo","hbw", "nhbo", "nhbw")
od_purpose_choices           = trip_purpose_choices
od_purpose_choices_short     = trip_purpose_choices_short
od_traveler_type_choices = poi_traveler_type_choices    = c("Residents", "Visitors", "Total")

poi_traveler_type_choices_o  = paste0(poi_traveler_type_choices, "_o")
poi_traveler_type_choices_d  = paste0(poi_traveler_type_choices, "_d")

od_selection_choices         = c("Origin", "Destination")

# to be used for "data_import.R" file. same names/path info in "data_preparation.R" --------
#R package required 
SYSTEM_PKGS <- c("tidyverse", "data.table", "leaflet", "plotly", "tigris", "sf", "sfarrow", "arrow" , 'shiny',
                 'shinyjs', 'shinyalert', 'shinycssloaders', 'shinydashboard', 'shinyWidgets', 'shinyFiles',
                 'htmltools', 'htmlwidgets', 'geojsonio', 'mapview', 'RColorBrewer', 'scales', 'Rfast', 'DT', 
                 'BAMMtools', 'reactable', 'reactablefmtr', 'purrr', 'readxl', 'mltools', 'DT', 'formattable')

lapply(SYSTEM_PKGS, require, character.only = TRUE)    # Load multiple packages

SYSTEM_APP_PATH = getwd()
# app input data file names --------
APP_INPUT_OD_TOTAL_GIS_DATA_NAME_2019 = "census_geos_2019.rds"
APP_INPUT_OD_TOTAL_GIS_DATA_NAME_2022 = "census_geos_2022.rds"


APP_INPUT_TRIP_CHAR_DATA_NAME1 = "trip_characteristics1_2019_2022.rds"
APP_INPUT_TRIP_CHAR_DATA_NAME2 = "trip_characteristics2_2019_2022.rds"
APP_INPUT_OD_TOTAL_DATA_NAME_2019     = "o_and_d_totals_2019.rds"
APP_INPUT_OD_TOTAL_DATA_NAME_2022     = "o_and_d_totals_2022.rds"
APP_INPUT_LINK_FLOWS_DATA_NAME_2019 = "link_flows_2019.rds"
APP_INPUT_LINK_FLOWS_DATA_NAME_2022 = "link_flows_2022.rds"
APP_INPUT_NETWORK_D7_EDGES_DATA_NAME_2019 = "d7_edges_2019.rds"
APP_INPUT_NETWORK_D7_EDGES_DATA_NAME_2022 = "d7_edges_2022.rds"
APP_INPUT_DATA_DIR_NAME = "data"
APP_INPUT_GIS_DATA_DIR_NAME = "data/gis"
APP_INPUT_SPEND_DATA_DIR_NAME = "data/spending"
APP_INPUT_LINK_FLOWS_DIR_NAME  = "link_flows"
APP_INPUT_TRIP_CHAR_DATA_DIR_NAME = "data/trip_characteristics"
APP_INPUT_LINK_FLOWS_BIN_LIST_NAME = "poi_od_flows_bins.rds"
APP_INPUT_RMERGE_OD_DATA_DIR_NAME = "data/previous_rsg_expanded_lbs"
APP_INPUT_RMERGE_OD_DATA_NAME_2019 = "rmerge_od_2019.rds"
APP_INPUT_REPLICA_OD_DIR_NAME  = "od_tables"
APP_INPUT_OD_TOTAL_DIR_NAME  = "o_and_d_totals"
APP_INPUT_REPLICA_OD_COLORPAL_NAME_2022 = "od_tables_2022_colorpal.rds"
APP_INPUT_REPLICA_OD_DATA_NAME_2022 = "od_tables_2022.rds"

# app data directory -------
APP_INPUT_DATA_PATH             = file.path(SYSTEM_APP_PATH, APP_INPUT_DATA_DIR_NAME)
APP_INPUT_GIS_DATA_PATH         = file.path(SYSTEM_APP_PATH, APP_INPUT_GIS_DATA_DIR_NAME)
APP_INPUT_SPEND_DATA_PATH       = file.path(SYSTEM_APP_PATH, APP_INPUT_SPEND_DATA_DIR_NAME)
APP_INPUT_REPLICA_OD_DATA_PATH  = file.path(APP_INPUT_DATA_PATH, APP_INPUT_REPLICA_OD_DIR_NAME)
APP_INPUT_RMERGE_OD_DATA_PATH   = file.path(SYSTEM_APP_PATH, APP_INPUT_RMERGE_OD_DATA_DIR_NAME)
APP_INPUT_OD_TOTAL_DATA_PATH    = file.path(APP_INPUT_DATA_PATH, APP_INPUT_OD_TOTAL_DIR_NAME)
APP_INPUT_LINK_FLOWS_DATA_PATH  = file.path(APP_INPUT_DATA_PATH, APP_INPUT_LINK_FLOWS_DIR_NAME)
APP_INPUT_TRIP_CHAR_DATA_PATH   = file.path(SYSTEM_APP_PATH, APP_INPUT_TRIP_CHAR_DATA_DIR_NAME)
# end  --------

dist_bin_list = list(dist1 = c("0_2"),
                     dist2 = c("2_4"),
                     dist3 = c("4_6"),
                     dist4 = c("6_8","8_10"),
                     dist5 = c("10_12","12_14","14_16","16_18","18_20"),
                     dist6 = c("20_22","22_24","24_26","26_28","28_30"),
                     dist7 = c("30_32","32_34","34_36","36_38","38_40"),
                     dist8 = c("40_42","42_44","44_46","46_48","48_50"),
                     dist9 = c("> 50"))

dist_bin_mean_list = c("0_2" = 1, "2_4" = 3, "4_6" = 5, "6_8" = 7, "8_10" = 9, "10_12" = 11, "12_14" = 13, "14_16" = 15, "16_18" = 17, "18_20" = 19, "20_22" = 21, 
                       "22_24" = 23, "24_26" = 25, "26_28" = 27, "28_30" = 29, "30_32" = 31, "32_34" = 33, "34_36" = 35, "36_38" = 37, "38_40" = 39, "40_42" = 41, 
                       "42_44" = 43, "44_46" = 45, "46_48" = 47, "48_50" = 49, "> 50" = 50) 

# map palette color
# rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
# display.brewer.all(type="seq")
palette_OD_color1       = "PuRd"
palette_OD_color2       = "PiYG"

palette_trip_color1  = "YlOrRd"
palette_trip_color2  = "YlGnBu"
palette_barchart_color1  = "Spectral"
palette_barchart_color2  = "YlGn" 

palette_color1      = "RdYlBu"
palette_color2      = "RdYlGn"
palette_color3      = "Orange"
palette_color4      = "Purples"

# map zoom level 
zone_zoom_level = 10

# interest_zone = interest_zone_choices
# GIS_OD_LINK_DT = INPUT_GIS_OD_LINKFLOWS_FILELIST[[which(gsub("_od_link_flows", "", names(INPUT_GIS_OD_LINKFLOWS_FILELIST)) %in% interest_zone)]]
# ODLINK_data    = GIS_OD_LINK_DT
# data_OD_link   = st_drop_geometry(ODLINK_data)
# sel_var_link   = "tot_flow" #test with tot_o
# sel_bins_link  = getJenksBreaks(data_OD_link[[sel_var_link]], 7)

# sel_bins_link_list = list(
#   bin_dtwon_tampa = c(1, 129, 455, 1096, 2276, 4282, 10348)
# )