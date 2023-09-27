# TAMPA Mobility Dashboard. Data Import.R
# Have to run prior to launch app.file. for data preparation (do not include with source function)
# Developed by Kyeongsu Kim and Reid Haefer at RSG
# latest update: 08-12-2023 15:09 by Kyeongsu Kim

rm(list=ls())
source(file.path(getwd(), "config_system_path.R"))


# Read spending data ========
## REPLICA County data
INPUT_spend_county_FILE <- file.path(APP_INPUT_SPEND_DATA_PATH, "spend_county.rds")
INPUT_spend_tract_FILE  <- file.path(APP_INPUT_SPEND_DATA_PATH, "spend_tract.rds")

if(!file.exists(INPUT_spend_county_FILE)){
  spend_county = fread(INPUT_REPLICA_COUNTY_PATH) #  %>% mutate(date=mdy(week_starting)) 
  spend_county[, date:=mdy(week_starting)]
  saveRDS(spend_county, file = file.path(APP_INPUT_SPEND_DATA_PATH, "spend_county.rds"))
}

if(!file.exists(INPUT_spend_tract_FILE)){
  # Read REPLICA Tract data
  spend_tract = fread(INPUT_REPLICA_TRACK_PATH) #  %>% mutate(date=mdy(week_starting)) 
  spend_tract[, date:=mdy(week_starting)]
  # spend_tract = sf::st_as_sf(spend_tract, crs=4326, coords=c('latitude','longitude'))
  saveRDS(spend_tract, file = file.path(APP_INPUT_SPEND_DATA_PATH, "spend_tract.rds"))
}

# Geometry County Place, TAZ and BG geo-spatial files =========
# Read STUDY_AREA (County Place, TAZ and BG) and POI geospatial data
INPUT_GIS_TAZ_FILE <- file.path(APP_INPUT_GIS_DATA_PATH, "gis_TAZ.rds")

gis_CPlace  = st_read_parquet(INPUT_STUDYAREA_CPLACE_PATH)
gis_TAZ     = st_read(INPUT_STUDYAREA_TAZ_PATH, quiet = TRUE)
gis_BG      = st_read(INPUT_STUDYAREA_BG_PATH, quiet = TRUE)
gis_POI     = st_read(INPUT_POI_PATH, quiet = TRUE)

saveRDS(gis_CPlace, file = file.path(APP_INPUT_GIS_DATA_PATH, "gis_CPlace.rds"))
saveRDS(gis_TAZ, file = file.path(APP_INPUT_GIS_DATA_PATH, "gis_TAZ.rds"))
saveRDS(gis_BG, file = file.path(APP_INPUT_GIS_DATA_PATH, "gis_BG.rds"))
saveRDS(gis_POI, file = file.path(APP_INPUT_GIS_DATA_PATH, "gis_POI.rds"))


# outputs files to app directory---------
## outputs\o_and_d_totals -------

if(!file.exists(file.path(APP_INPUT_OD_TOTAL_DATA_PATH, APP_INPUT_OD_TOTAL_DATA_NAME_2019))){
  # 2019
  cat("------- file path for INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2019 -------\n") 
  print(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2019)
  
  INPUT_OD_LIST_2019            = list.files(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2019, pattern='od.parquet')
  INPUT_ALL_LIST_2019           = list.files(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2019, pattern='all.parquet') 
  INPUT_PASSTHROUGH_LIST_2019   = list.files(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2019, pattern='passthrough.parquet')
  
  INPUT_OD_LIST_2019 = INPUT_OD_LIST_2019[!INPUT_OD_LIST_2019 %in% "d7_od.parquet"]
  INPUT_ALL_LIST_2019 = INPUT_ALL_LIST_2019[!INPUT_ALL_LIST_2019 %in% "d7_od.parquet"]
  INPUT_PASSTHROUGH_LIST_2019 = INPUT_PASSTHROUGH_LIST_2019[!INPUT_PASSTHROUGH_LIST_2019 %in% "d7_od.parquet"]
  
  cat("------- file path for APP_INPUT_OD_TOTAL_DATA_PATH_2019  -------\n") 
  print(APP_INPUT_OD_TOTAL_DATA_PATH_2019)
  INPUT_OD_FILE_PATHS_2019          = file.path(APP_INPUT_OD_TOTAL_DATA_PATH_2019, gsub("parquet", "rds", INPUT_OD_LIST_2019))
  INPUT_ALL_FILE_PATHS_2019         = file.path(APP_INPUT_OD_TOTAL_DATA_PATH_2019, gsub("parquet", "rds", INPUT_ALL_LIST_2019))
  INPUT_PASSTHROUGH_FILE_PATHS_2019 = file.path(APP_INPUT_OD_TOTAL_DATA_PATH_2019, gsub("parquet", "rds", INPUT_PASSTHROUGH_LIST_2019))
  
  INPUT_OD_FILELIST_2019   <- lapply(file.path(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2019, INPUT_OD_LIST_2019), read_parquet) # no geometry
  names(INPUT_OD_FILELIST_2019)  <- gsub(".parquet","", INPUT_OD_LIST_2019)
  
  saveRDS(INPUT_OD_FILELIST_2019, file = file.path(APP_INPUT_OD_TOTAL_DATA_PATH, APP_INPUT_OD_TOTAL_DATA_NAME_2019))
  rm(INPUT_OD_FILELIST_2019)
}
 

if(!file.exists(file.path(APP_INPUT_OD_TOTAL_DATA_PATH, APP_INPUT_OD_TOTAL_DATA_NAME_2022))){
  # 2022
  INPUT_OD_LIST_2022            = list.files(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2022, pattern='od.parquet')
  INPUT_ALL_LIST_2022           = list.files(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2022, pattern='all.parquet') 
  INPUT_PASSTHROUGH_LIST_2022   = list.files(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2022, pattern='passthrough.parquet')
  
  INPUT_OD_LIST_2022 = INPUT_OD_LIST_2022[!INPUT_OD_LIST_2022 %in% "d7_od.parquet"]
  INPUT_ALL_LIST_2022 = INPUT_ALL_LIST_2022[!INPUT_ALL_LIST_2022 %in% "d7_od.parquet"]
  INPUT_PASSTHROUGH_LIST_2022 = INPUT_PASSTHROUGH_LIST_2022[!INPUT_PASSTHROUGH_LIST_2022 %in% "d7_od.parquet"]
  
  INPUT_OD_FILE_PATHS_2022          = file.path(APP_INPUT_OD_TOTAL_DATA_PATH_2022, gsub("parquet", "rds", INPUT_OD_LIST_2022))
  INPUT_ALL_FILE_PATHS_2022         = file.path(APP_INPUT_OD_TOTAL_DATA_PATH_2022, gsub("parquet", "rds", INPUT_ALL_LIST_2022))
  INPUT_PASSTHROUGH_FILE_PATHS_2022 = file.path(APP_INPUT_OD_TOTAL_DATA_PATH_2022, gsub("parquet", "rds", INPUT_PASSTHROUGH_LIST_2022))
  
  INPUT_OD_FILELIST_2022   <- lapply(file.path(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2022, INPUT_OD_LIST_2022), read_parquet) # no geometry
  names(INPUT_OD_FILELIST_2022)  <- gsub(".parquet","", INPUT_OD_LIST_2022)
  
  saveRDS(INPUT_OD_FILELIST_2022, file = file.path(APP_INPUT_OD_TOTAL_DATA_PATH, APP_INPUT_OD_TOTAL_DATA_NAME_2022))
  rm(INPUT_OD_FILELIST_2022)
}


if(!file.exists(file.path(APP_INPUT_GIS_DATA_PATH, APP_INPUT_OD_TOTAL_GIS_DATA_NAME_2019))){
  cat("------- file path for INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2019_GIS_PATH -------\n") 
  print(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2019_GIS_PATH); 
  INPUT_OD_GIS_2019 <- st_read_parquet(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2019_GIS_PATH)
  saveRDS(INPUT_OD_GIS_2019, file = file.path(APP_INPUT_GIS_DATA_PATH, APP_INPUT_OD_TOTAL_GIS_DATA_NAME_2019))
  rm(INPUT_OD_GIS_2019)
}

if(!file.exists(file.path(APP_INPUT_GIS_DATA_PATH, APP_INPUT_OD_TOTAL_GIS_DATA_NAME_2022))){
  cat("------- file path for INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2022_GIS_PATH -------\n") 
  print(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2022_GIS_PATH); 
  INPUT_OD_GIS_2022 <- st_read_parquet(INPUT_OUTPUTS_OD_TOTAL_DATA_PATH_2022_GIS_PATH)
  saveRDS(INPUT_OD_GIS_2022, file = file.path(APP_INPUT_GIS_DATA_PATH, APP_INPUT_OD_TOTAL_GIS_DATA_NAME_2022))
  rm(INPUT_OD_GIS_2022)
}


if(!file.exists(file.path(APP_INPUT_REPLICA_OD_DATA_PATH, APP_INPUT_REPLICA_OD_DATA_NAME_2022))){
  ## outputs\od_tables -------
  INPUT_OUTPUTS_REPLICA_OD_DATA = list.files(INPUT_OUTPUTS_REPLICA_OD_DATA_PATH, pattern='csv') 
  INPUT_REPLICA_OD_DATA_LIST   <- lapply(file.path(INPUT_OUTPUTS_REPLICA_OD_DATA_PATH, INPUT_OUTPUTS_REPLICA_OD_DATA), fread) # st_read_parquet
  names(INPUT_REPLICA_OD_DATA_LIST)  <- gsub(".csv","", INPUT_OUTPUTS_REPLICA_OD_DATA)

  INPUT_REPLICA_OD_DATA_LIST1 = data.table(INPUT_REPLICA_OD_DATA_LIST[[2]])
  # INPUT_REPLICA_OD_DATA_LIST2 = INPUT_REPLICA_OD_DATA_LIST[[2]]
  INPUT_REPLICA_OD_DATA_LIST1$type[INPUT_REPLICA_OD_DATA_LIST1$market %in% c("visitor_from_outside","visitor_from_south_atlantic")] = "Visitors"
  INPUT_REPLICA_OD_DATA_LIST1$type[INPUT_REPLICA_OD_DATA_LIST1$market %in% c("resident")] = "Residents"
  INPUT_REPLICA_OD_DATA_LIST1_od = INPUT_REPLICA_OD_DATA_LIST1[, lapply(.SD, sum), by=c("origin", "destination", "type"), .SDcols = c("trips")]
  INPUT_REPLICA_OD_DATA_LIST1_total_od = INPUT_REPLICA_OD_DATA_LIST1_od[, lapply(.SD, sum), by=c("origin", "destination"), .SDcols = c("trips")]
  INPUT_REPLICA_OD_DATA_LIST1_total_od$type = "Total"
  
  INPUT_REPLICA_OD_DATA_LIST1 = rbind(INPUT_REPLICA_OD_DATA_LIST1_od, INPUT_REPLICA_OD_DATA_LIST1_total_od )
  INPUT_REPLICA_OD_DATA_LIST  = data.table(INPUT_REPLICA_OD_DATA_LIST1, year=2022)
  
  # INPUT_REPLICA_OD_DATA_LIST2 = rbind(INPUT_REPLICA_OD_DATA_LIST2, INPUT_REPLICA_OD_DATA_LIST2_total_od )
  # INPUT_REPLICA_OD_DATA_LIST2  = data.table(INPUT_REPLICA_OD_DATA_LIST2, year=2022) 
  # INPUT_REPLICA_OD_DATA_LIST = rbind(INPUT_REPLICA_OD_DATA_LIST1, INPUT_REPLICA_OD_DATA_LIST2)
  
  INPUT_REPLICA_OD_DATA_LIST_otrip = INPUT_REPLICA_OD_DATA_LIST[, lapply(.SD, sum), by=c("origin", "year", "type"), .SDcols = c("trips")]
  INPUT_REPLICA_OD_DATA_LIST_otrip$variable = "Origin"
  names(INPUT_REPLICA_OD_DATA_LIST_otrip)[1] = "zone"
  INPUT_REPLICA_OD_DATA_LIST_dtrip = INPUT_REPLICA_OD_DATA_LIST[, lapply(.SD, sum), by=c("destination", "year", "type"), .SDcols = c("trips")]
  # names(INPUT_REPLICA_OD_DATA_LIST_dtrip)[5] = "Destination"
  INPUT_REPLICA_OD_DATA_LIST_dtrip$variable = "Destination"
  names(INPUT_REPLICA_OD_DATA_LIST_dtrip)[1] = "zone"

  
  gis_TAZ     = gis_TAZ[, c("ZONE", "COUNTY", "geom")]; names(gis_TAZ) = tolower(names(gis_TAZ))
  names(gis_TAZ)[1] = "zone"

  type_list = unique(INPUT_REPLICA_OD_DATA_LIST_dtrip$type)
  
  replica_o_2022_sf_list = list();
  replica_d_2022_sf_list = list()
  replica_sel_colorpal_zone_list = list()
  sel_colorpal_zone_o_list = list()
  sel_colorpal_zone_d_list = list()
  
  for(i in 1:length(type_list)) {
    # i=1
    dt_o = INPUT_REPLICA_OD_DATA_LIST_otrip[INPUT_REPLICA_OD_DATA_LIST_otrip$type %in% type_list[i]]
    dt_d = INPUT_REPLICA_OD_DATA_LIST_dtrip[INPUT_REPLICA_OD_DATA_LIST_dtrip$type %in% type_list[i]]
    replica_o_2022_sf_list[[i]] <- gis_TAZ %>% merge(dt_o, by = 'zone', all.x=TRUE)
    replica_d_2022_sf_list[[i]] <- gis_TAZ %>% merge(dt_d, by = 'zone', all.x=TRUE) 
    names(replica_o_2022_sf_list)[i] = type_list[i]
    names(replica_d_2022_sf_list)[i] = type_list[i]
    
    if(type_list[i]=="Visitors"){
      sel_bins_zone_o <- round(BAMMtools::getJenksBreaks(dt_o$trips, 5),-1)
      sel_colorpal_zone_o <- colorBin(palette = palette_color4,  bins= sel_bins_zone_o)
      sel_bins_zone_d <- round(BAMMtools::getJenksBreaks(dt_d$trips, 5),-1)
      sel_colorpal_zone_d <- colorBin(palette = palette_color4,  bins= sel_bins_zone_d)
    } else {
      sel_bins_zone_o <- round(BAMMtools::getJenksBreaks(dt_o$trips, 10),-1)
      sel_colorpal_zone_o <- colorBin(palette = palette_color4,  bins= sel_bins_zone_o)
      sel_bins_zone_d <- round(BAMMtools::getJenksBreaks(dt_d$trips, 10),-1)
      sel_colorpal_zone_d <- colorBin(palette = palette_color4,  bins= sel_bins_zone_d)
    }
    
    sel_colorpal_zone_o_list[[i]] = sel_colorpal_zone_o
    sel_colorpal_zone_d_list[[i]] = sel_colorpal_zone_d
    names(sel_colorpal_zone_o_list)[i] = type_list[i]
    names(sel_colorpal_zone_d_list)[i] = type_list[i]
  }
  
  replica_od_2022_sf_list = list(replica_o_2022_sf_list, replica_d_2022_sf_list)
  replica_sel_colorpal_zone_list = list(sel_colorpal_zone_o_list, sel_colorpal_zone_d_list)
  names(replica_od_2022_sf_list) = c("Origin", "Destination")
  names(replica_sel_colorpal_zone_list) = c("Origin", "Destination")
  
  # INPUT_REPLICA_OD_DATA_LIST_odtrip = merge(INPUT_REPLICA_OD_DATA_LIST_otrip, INPUT_REPLICA_OD_DATA_LIST_dtrip, by = c("zone", "year", "type"))
  # INPUT_REPLICA_OD_DATA_LIST_odtrip = rbind(INPUT_REPLICA_OD_DATA_LIST_otrip, INPUT_REPLICA_OD_DATA_LIST_dtrip)
  # INPUT_REPLICA_OD_DATA_LIST_odtrip_long = melt(INPUT_REPLICA_OD_DATA_LIST_odtrip, id.vars=c("zone","year", "market", "purpose"))
  
  saveRDS(replica_sel_colorpal_zone_list, file = file.path(APP_INPUT_REPLICA_OD_DATA_PATH, APP_INPUT_REPLICA_OD_COLORPAL_NAME_2022))
  saveRDS(replica_od_2022_sf_list, file = file.path(APP_INPUT_REPLICA_OD_DATA_PATH, APP_INPUT_REPLICA_OD_DATA_NAME_2022))
  # saveRDS(INPUT_REPLICA_OD_DATA_LIST_odtrip_long, file = file.path(APP_INPUT_REPLICA_OD_DATA_PATH, APP_INPUT_OD_REPLICA_DATA_LONG_NAME))
}



## outputs\link_flows -------
if(!file.exists(file.path(APP_INPUT_LINK_FLOWS_DATA_PATH, APP_INPUT_LINK_FLOWS_DATA_NAME_2019))){
  # 2019
  INPUT_OD_LINK_FLOWS_LIST_2019            = list.files(INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH_2019, pattern='od_link_flows.parquet')
  INPUT_ALL_LINK_FLOWS_LIST_2019           = list.files(INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH_2019, pattern='all_link_flows.parquet') 
  INPUT_PASSTHROUGH_LINK_FLOWS_LIST_2019   = list.files(INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH_2019, pattern='passthrough_link_flows.parquet')
  
  INPUT_OD_LINK_FLOWS_FILE_PATHS_2019          = file.path(APP_INPUT_LINK_FLOWS_DATA_PATH_2019, gsub("parquet", "rds", INPUT_OD_LINK_FLOWS_LIST_2019))
  INPUT_ALL_LINK_FLOWS_FILE_PATHS_2019         = file.path(APP_INPUT_LINK_FLOWS_DATA_PATH_2019, gsub("parquet", "rds", INPUT_ALL_LINK_FLOWS_LIST_2019))
  INPUT_PASSTHROUGH_LINK_FLOWS_FILE_PATHS_2019 = file.path(APP_INPUT_LINK_FLOWS_DATA_PATH_2019, gsub("parquet", "rds", INPUT_PASSTHROUGH_LINK_FLOWS_LIST_2019))
  
  INPUT_OD_LINK_FLOWS_FILELIST_2019   <- lapply(file.path(INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH_2019, INPUT_OD_LINK_FLOWS_LIST_2019), read_parquet) # no geometry
  names(INPUT_OD_LINK_FLOWS_FILELIST_2019)  <- gsub(".parquet","", INPUT_OD_LINK_FLOWS_LIST_2019)
  # Map(saveRDS, INPUT_OD_LINK_FLOWS_FILELIST_2019, file = paste0(APP_INPUT_LINK_FLOWS_DATA_PATH_2019, "/", names(INPUT_OD_LINK_FLOWS_FILELIST_2019), ".rds"))
  saveRDS(INPUT_OD_LINK_FLOWS_FILELIST_2019, file = file.path(APP_INPUT_LINK_FLOWS_DATA_PATH, APP_INPUT_LINK_FLOWS_DATA_NAME_2019))
  rm(INPUT_OD_LINK_FLOWS_FILELIST_2019)
}

if(!file.exists(file.path(APP_INPUT_LINK_FLOWS_DATA_PATH, APP_INPUT_LINK_FLOWS_DATA_NAME_2022))){
  # 2022
  INPUT_OD_LINK_FLOWS_LIST_2022            = list.files(INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH_2022, pattern='od_link_flows.parquet')
  INPUT_ALL_LINK_FLOWS_LIST_2022           = list.files(INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH_2022, pattern='all_link_flows.parquet') 
  INPUT_PASSTHROUGH_LINK_FLOWS_LIST_2022   = list.files(INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH_2022, pattern='passthrough_link_flows.parquet')
  
  INPUT_OD_LINK_FLOWS_FILE_PATHS_2022          = file.path(APP_INPUT_LINK_FLOWS_DATA_PATH_2022, gsub("parquet", "rds", INPUT_OD_LINK_FLOWS_LIST_2022))
  INPUT_ALL_LINK_FLOWS_FILE_PATHS_2022         = file.path(APP_INPUT_LINK_FLOWS_DATA_PATH_2022, gsub("parquet", "rds", INPUT_ALL_LINK_FLOWS_LIST_2022))
  INPUT_PASSTHROUGH_LINK_FLOWS_FILE_PATHS_2022 = file.path(APP_INPUT_LINK_FLOWS_DATA_PATH_2022, gsub("parquet", "rds", INPUT_PASSTHROUGH_LINK_FLOWS_LIST_2022))
  
  INPUT_OD_LINK_FLOWS_FILELIST_2022   <- lapply(file.path(INPUT_OUTPUTS_LINK_FLOWS_DATA_PATH_2022, INPUT_OD_LINK_FLOWS_LIST_2022), read_parquet) # st_read_parquet
  names(INPUT_OD_LINK_FLOWS_FILELIST_2022)  <- gsub(".parquet","", INPUT_OD_LINK_FLOWS_LIST_2022)
  
  saveRDS(INPUT_OD_LINK_FLOWS_FILELIST_2022, file = file.path(APP_INPUT_LINK_FLOWS_DATA_PATH, APP_INPUT_LINK_FLOWS_DATA_NAME_2022))
  rm(INPUT_OD_LINK_FLOWS_FILELIST_2022)
}


## Geometry\network (to be linked to link flows ) -------
if(!file.exists(file.path(APP_INPUT_GIS_DATA_PATH, APP_INPUT_NETWORK_D7_EDGES_DATA_NAME_2019))){
  INPUT_NETWORK_D7_EDGES_FILE_2019   <- st_read_parquet(INPUT_NETWORK_D7_EDGES_PATH_2019)
  names(INPUT_NETWORK_D7_EDGES_FILE_2019)
  INPUT_NETWORK_D7_EDGES_FILE_2019 = INPUT_NETWORK_D7_EDGES_FILE_2019[, c("stableEdge", "geometry")]
  saveRDS(INPUT_NETWORK_D7_EDGES_FILE_2019, file = file.path(APP_INPUT_GIS_DATA_PATH, APP_INPUT_NETWORK_D7_EDGES_DATA_NAME_2019))
  rm(INPUT_NETWORK_D7_EDGES_FILE_2019)
}

if(!file.exists(file.path(APP_INPUT_GIS_DATA_PATH, APP_INPUT_NETWORK_D7_EDGES_DATA_NAME_2022))){
  INPUT_NETWORK_D7_EDGES_FILE_2022   <- st_read_parquet(INPUT_NETWORK_D7_EDGES_PATH_2022)
  INPUT_NETWORK_D7_EDGES_FILE_2022 = INPUT_NETWORK_D7_EDGES_FILE_2022[, c("stableEdge", "geometry")]
  saveRDS(INPUT_NETWORK_D7_EDGES_FILE_2022, file = file.path(APP_INPUT_GIS_DATA_PATH, APP_INPUT_NETWORK_D7_EDGES_DATA_NAME_2022))
  rm(INPUT_NETWORK_D7_EDGES_FILE_2022)
}


## outputs\trip characteristics data files =========
# Read trip characteristics data1
if(!file.exists(file.path(APP_INPUT_TRIP_CHAR_DATA_PATH, APP_INPUT_TRIP_CHAR_DATA_NAME1))){
  INPUT_OUTPUTS_TRIP_CHAR_LIST = list.files(INPUT_OUTPUTS_TRIP_CHAR_PATH, pattern='csv') 
  INPUT_OUTPUTS_TRIP_CHAR_LIST_FILES <- lapply(file.path(INPUT_OUTPUTS_TRIP_CHAR_PATH, INPUT_OUTPUTS_TRIP_CHAR_LIST), fread)
  names(INPUT_OUTPUTS_TRIP_CHAR_LIST_FILES)  <- gsub(".csv","", INPUT_OUTPUTS_TRIP_CHAR_LIST)
  saveRDS(INPUT_OUTPUTS_TRIP_CHAR_LIST_FILES, file = file.path(APP_INPUT_TRIP_CHAR_DATA_PATH, APP_INPUT_TRIP_CHAR_DATA_NAME1))
  rm(INPUT_OUTPUTS_TRIP_CHAR_LIST_FILES)
}

# Read trip characteristics data2
if(!file.exists(file.path(APP_INPUT_TRIP_CHAR_DATA_PATH, APP_INPUT_TRIP_CHAR_DATA_NAME2))){
  INPUT_OUTPUTS_TRIP_CHAR_2019_LIST = list.files(INPUT_OUTPUTS_TRIP_CHAR_PATH_2019, pattern='csv') 
  INPUT_OUTPUTS_TRIP_CHAR_2022_LIST = list.files(INPUT_OUTPUTS_TRIP_CHAR_PATH_2022, pattern='csv') 
  INPUT_OUTPUTS_TRIP_CHAR_2019_LIST_FILES <- lapply(file.path(INPUT_OUTPUTS_TRIP_CHAR_PATH_2019, INPUT_OUTPUTS_TRIP_CHAR_2019_LIST), fread)
  names(INPUT_OUTPUTS_TRIP_CHAR_2019_LIST_FILES)  <- gsub(".csv","", INPUT_OUTPUTS_TRIP_CHAR_2019_LIST)
  INPUT_OUTPUTS_TRIP_CHAR_2022_LIST_FILES <- lapply(file.path(INPUT_OUTPUTS_TRIP_CHAR_PATH_2022, INPUT_OUTPUTS_TRIP_CHAR_2022_LIST), fread)
  names(INPUT_OUTPUTS_TRIP_CHAR_2022_LIST_FILES)  <- gsub(".csv","", INPUT_OUTPUTS_TRIP_CHAR_2022_LIST)
  
  for(i in 1:length(zone_choices_list)) {
    INPUT_OUTPUTS_TRIP_CHAR_2019_LIST_FILES[[1]]$area[INPUT_OUTPUTS_TRIP_CHAR_2019_LIST_FILES[[1]]$poi %in% zone_choices_list[i]] <- names(zone_choices_list)[i]
    INPUT_OUTPUTS_TRIP_CHAR_2022_LIST_FILES[[1]]$area[INPUT_OUTPUTS_TRIP_CHAR_2022_LIST_FILES[[1]]$poi %in% zone_choices_list[i]] <- names(zone_choices_list)[i]
  }
  
  Map(saveRDS, INPUT_OUTPUTS_TRIP_CHAR_2019_LIST_FILES, file = paste0(APP_INPUT_TRIP_CHAR_DATA_PATH, "/", names(INPUT_OUTPUTS_TRIP_CHAR_2019_LIST_FILES), ".rds"))
  Map(saveRDS, INPUT_OUTPUTS_TRIP_CHAR_2022_LIST_FILES, file = paste0(APP_INPUT_TRIP_CHAR_DATA_PATH, "/", names(INPUT_OUTPUTS_TRIP_CHAR_2022_LIST_FILES), ".rds"))
  INPUT_OUTPUTS_TRIP_CHAR_2019_2022_LIST_FILES = list(INPUT_OUTPUTS_TRIP_CHAR_2019_LIST_FILES, INPUT_OUTPUTS_TRIP_CHAR_2022_LIST_FILES)
  saveRDS(INPUT_OUTPUTS_TRIP_CHAR_2019_2022_LIST_FILES, file = file.path(APP_INPUT_TRIP_CHAR_DATA_PATH, APP_INPUT_TRIP_CHAR_DATA_NAME2))
  rm(INPUT_OUTPUTS_TRIP_CHAR_2019_LIST_FILES, INPUT_OUTPUTS_TRIP_CHAR_2022_LIST_FILES); rm(INPUT_OUTPUTS_TRIP_CHAR_2019_2022_LIST_FILES)
}

## previous_rsg_expanded_lbs\od data files =========


if(!file.exists(file.path(APP_INPUT_RMERGE_OD_DATA_PATH, APP_INPUT_OD_RMERGE_DATA_NAME_2019))){

  INPUT_RMERGE_DATA_PATH_INTERNAL <- data.table(read_parquet(INPUT_RMERGE_DATA_PATH_INTERNAL_OD_PATH)) 
  INPUT_RMERGE_DATA_PATH_EXTERNAL <- data.table(read_parquet(INPUT_RMERGE_DATA_PATH_EXTERNAL_OD_PATH))
  INPUT_RMERGE_DATA_PATH_EXTERNAL[, Residents := Residents_AM + Residents_MD + Residents_PM + Residents_NT]
  INPUT_RMERGE_DATA_PATH_EXTERNAL[, Visitors := Visitors_AM + Visitors_MD + Visitors_PM + Visitors_NT]
  
  INPUT_RMERGE_DATA = rbind(INPUT_RMERGE_DATA_PATH_INTERNAL, INPUT_RMERGE_DATA_PATH_EXTERNAL, fill=TRUE)
  INPUT_RMERGE_DATA_otrip = INPUT_RMERGE_DATA[, lapply(.SD, sum, na.rm=TRUE), by=c("Origin"), .SDcols = c("Daily", "Residents", "Visitors")]
  INPUT_RMERGE_DATA_dtrip = INPUT_RMERGE_DATA[, lapply(.SD, sum, na.rm=TRUE), by=c("Destination"), .SDcols = c("Daily", "Residents", "Visitors")]
  
  INPUT_RMERGE_DATA_otrip$variable = "Origin"
  INPUT_RMERGE_DATA_dtrip$variable = "Destination"
  
  names(INPUT_RMERGE_DATA_otrip)[1]  <- "zone"
  names(INPUT_RMERGE_DATA_dtrip)[1]  <- "zone"
  
  INPUT_RMERGE_DATA = rbind(INPUT_RMERGE_DATA_otrip, INPUT_RMERGE_DATA_dtrip)
  names(INPUT_RMERGE_DATA)[2] ="Total"
  
  INPUT_RMERGE_DATA_long = melt(INPUT_RMERGE_DATA, id.vars=c("zone","variable"))
  names(INPUT_RMERGE_DATA_long)[3] = "type"
  names(INPUT_RMERGE_DATA_long)[4] = "trips"
  INPUT_RMERGE_DATA_long$year = 2019
  saveRDS(INPUT_RMERGE_DATA_long, file = file.path(APP_INPUT_RMERGE_OD_DATA_PATH, APP_INPUT_OD_RMERGE_DATA_NAME_2019))
}



# to create natural break 10.poi flows bins (it takes lots of time, so it needs to be pre-prared) ===========


if(!file.exists(file.path(APP_INPUT_LINK_FLOWS_DATA_PATH, APP_INPUT_LINK_FLOWS_BIN_LIST_NAME))){
    
  sel_year = c(2019, 2022)
  zone_choices_list = c("Busch Gardens" = 1, "Clear Water Beach" = 2 , "Crystal River Wildlife Areas" = 3, "Downtown St Petersburg" = 4, "Downtown Tampa" = 5, "Hernando Beach" = 6, 
                        "Port Tampa Bay Cruise Terminals and Florida Aquarium" = 7, "Raymond James Stadium" = 8 , "Tropicana Stadium" = 9, "Weekiwachee Gardens and Wildlife Areas" = 10)
  zone_choices = names(zone_choices_list)
  poi_traveler_type_choices     = c("resident", "visitor", "total")
  
  INPUT_OD_LINK_FLOWS_FILELIST_2019   <- lapply(file.path(APP_INPUT_LINK_FLOWS_DATA_PATH, APP_INPUT_LINK_FLOWS_DATA_NAME_2019), readRDS)[[1]]
  INPUT_OD_LINK_FLOWS_FILELIST_2022   <- lapply(file.path(APP_INPUT_LINK_FLOWS_DATA_PATH, APP_INPUT_LINK_FLOWS_DATA_NAME_2022), readRDS)[[1]]
  
  APP_POI_OD_LINK_FLOWS = list(INPUT_OD_LINK_FLOWS_FILELIST_2019,INPUT_OD_LINK_FLOWS_FILELIST_2022)
  
  # i=1; z=9
  sel_poi_od_flow_bin_year_list =list()
  
  for (i in 1:length(sel_year)) {
    poi_od_flow = APP_POI_OD_LINK_FLOWS[[i]]
    sel_poi_od_flow_bin_list= list()
    for(z in 1:length(zone_choices)) {
      sel_poi_od_flow = poi_od_flow[[which(gsub("_od_link_flows", "", names(poi_od_flow)) %in% zone_choices[[z]])]]
      sel_poi_od_flow = data.table(sel_poi_od_flow)
      sel_poi_od_flow[, visitor := visitor_from_outside + visitor_from_south_atlantic]
      
      sel_poi_od_flow_res = sel_poi_od_flow[sel_poi_od_flow[[2]]>1,]
      # sel_poi_od_flow_vis_out = sel_poi_od_flow[sel_poi_od_flow[[3]]>1,]
      # sel_poi_od_flow_vis_so_atlantic = sel_poi_od_flow[sel_poi_od_flow[[4]]>1,]
      sel_poi_od_flow_tot = sel_poi_od_flow[sel_poi_od_flow[[5]]>1,]
      sel_poi_od_flow_vis = sel_poi_od_flow[sel_poi_od_flow[[6]]>1,]
      
      sel_poi_od_flow_res_bins <- round(getJenksBreaks(sel_poi_od_flow_res[[2]], 7), -1)
      # sel_poi_od_flow_vis_out_bins <- round(getJenksBreaks(sel_poi_od_flow_vis_out[[3]], 7),-1)
      # sel_poi_od_flow_vis_so_atlantic_bins <- round(getJenksBreaks(sel_poi_od_flow_vis_so_atlantic[[4]], 7),-1)
      sel_poi_od_flow_tot_bins <- round(getJenksBreaks(sel_poi_od_flow_tot[[5]], 7), -1)
      sel_poi_od_flow_vis_bins <- round(getJenksBreaks(sel_poi_od_flow_vis[[6]], 7),-1)
      
      sel_poi_od_flow_bin_list[[z]] = list(sel_poi_od_flow_res_bins, sel_poi_od_flow_vis_bins,  sel_poi_od_flow_tot_bins)
      names(sel_poi_od_flow_bin_list[[z]]) = poi_traveler_type_choices
    }
    
    names(sel_poi_od_flow_bin_list) = gsub("_od_link_flows", "", names(poi_od_flow))
    sel_poi_od_flow_bin_year_list[[i]] = sel_poi_od_flow_bin_list
    rm(sel_poi_od_flow_bin_list)
  }
  
  saveRDS(sel_poi_od_flow_bin_year_list, file = file.path(APP_INPUT_LINK_FLOWS_DATA_PATH, APP_INPUT_LINK_FLOWS_BIN_LIST_NAME))

}


  
  
  
##### Reid Data Loading and processing ####

### server_6_LBS.R ######
vis_lbs_home <- read_csv("data/visitor_data/lbs/combined_home_locations.csv") %>% 
  filter(!is.na(latitude)) %>%
  st_as_sf(crs=4326,coords=c("longitude","latitude"))

vis_lbs_home_d7 <- st_join(vis_lbs_home, gis_d7 %>% st_set_crs(4326), largest=T)
vis_lbs_home_d7_state <- st_join(vis_lbs_home_d7, gis_state %>% select(NAME), largest=T)

vis_lbs_home_d7_state_df <- vis_lbs_home_d7_state %>% data.frame() %>%
  mutate(category=case_when(!NAME %in% c("Florida","Georgia","South Carolina") ~ "Outside Megaregion",
                            !is.na(d7) ~ "Inside District 7",
                            TRUE ~ as.character("Outside District 7"))) %>%
  mutate(total=sum(count,na.rm=T), percent=count/total)

vis_lbs_home_state <-st_join(gis_state, vis_lbs_home) %>% data.frame() %>%
  group_by(NAME) %>%
  summarise(count=sum(count,na.rm=T))
vis_lbs_home_state <- gis_state %>% left_join(vis_lbs_home_state, by="NAME") %>%
  filter(NAME != "Florida")

# write data
saveRDS(vis_lbs_home_state, file = "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\vis_lbs_home_state.rds")

write_parquet(vis_lbs_home_d7_state_df %>% select(-geometry), "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\vis_lbs_home_d7_state_df.parquet")

#####

lu<-read_excel("data/TampaSurvey_LandUse_Summary.xlsx", sheet="cleaned") %>%
  filter(value_type=="absolute") %>%
  pivot_longer(cols=3:12, names_to = "POI", values_to = "value")

write_parquet(lu, "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\land_use.parquet")

######

vis_home_loc_basic <- read_csv("data/visitor_data/replica/combined_home_locations.csv") 

vis_home_loc_sf <- vis_home_loc_basic %>% 
  filter(!is.na(INTPTLAT)) %>%
  st_as_sf(crs=4326,coords=c("INTPTLON","INTPTLAT"))

vis_bg<-st_join(gis_BG, vis_home_loc_sf) %>% data.frame() %>%
  group_by(FIPS_bgrp) %>%
  summarise(`2019`=sum(`X2019`,na.rm=T),
            `2022`=sum(`X2022`,na.rm=T))
vis_bg_sf <- gis_BG %>%
  left_join(vis_bg, by="FIPS_bgrp")

saveRDS(vis_bg_sf, file = "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\vis_bg_sf.rds")

### visitor population

vis_pop <- read_csv("data/visitor_data/replica/total_visitor_counts.csv") 

######## visitor trips/locations

vis_home_loc_replica <- vis_home_loc_basic%>%
  pivot_longer(cols=c(`2019`,`2022`), values_to = "count", names_to = "year") %>%
  pivot_longer(cols='home_placename', values_to = "value", names_to = "metric") %>%
  rename(POI=`...1`)

vis_work_loc_replica <- read_csv("data/visitor_data/replica/combined_work_locations.csv")  %>%
  pivot_longer(cols=c(`2019`,`2022`), values_to = "count", names_to = "year") %>%
  pivot_longer(cols='work_placename', values_to = "value", names_to = "metric") %>%
  rename(POI=`...1`)

vis_income_replica <- read_csv("data/visitor_data/replica/combined_hh_income.csv") %>%
  pivot_longer(cols=c(`2019`,`2022`), values_to = "count", names_to = "year") %>%
  pivot_longer(cols='household_income', values_to = "value", names_to = "metric")

vis_hh_size_replica <- read_csv("data/visitor_data/replica/combined_hh_sizes.csv") %>%
  pivot_longer(cols=c(`2019`,`2022`), values_to = "count", names_to = "year") %>%
  pivot_longer(cols='household_size', values_to = "value", names_to = "metric") %>%
  rename(POI=`...1`)

vis_trip_purpose_replica <- read_csv("data/visitor_data/replica/combined_trip_purposes.csv") %>%
  pivot_longer(cols=c(`2019`,`2022`), values_to = "count", names_to = "year") %>%
  pivot_longer(cols='purpose', values_to = "value", names_to = "metric") %>%
  rename(POI=`...1`)

vis_replica_clean <- bind_rows(vis_trip_purpose_replica,vis_hh_size_replica,vis_income_replica,vis_work_loc_replica,vis_home_loc_replica)

write_parquet(vis_replica_clean, "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\vis_replica_clean.parquet")

viz_home<-fread("data/vis_home_loc/all_home_locations.csv") %>%
  filter(home_placename !="Outside megaregion") %>%
  st_as_sf(crs=4326, coords=c("INTPTLON","INTPTLAT"))

### commercial vehicles #####

tod_19<-read_parquet("data\\reid_data\\commerical_vehicle\\2019\\commerical_tod_table.parquet")%>%
  mutate(year='2019')
trip_19<-read_parquet("data\\reid_data\\commerical_vehicle\\2019\\commerical_trip_table.parquet")%>%
  mutate(year='2019')
tod_22<-read_parquet("data\\reid_data\\commerical_vehicle\\2022\\commerical_tod_table.parquet")%>%
  mutate(year='2022')
trip_22<-read_parquet("data\\reid_data\\commerical_vehicle\\2022\\commerical_trip_table.parquet") %>%
  mutate(year='2022')

trip_all_final <- bind_rows(trip_22,trip_19) %>%
  rename_at(vars(poi_1:poi_10), ~ c("Downtown Tampa", "Busch Gardens", "Clear Water Beach",
                                    "Crystal River Wildlife Areas", "Downtown St Petersburg", "Hernando Beach",
                                    "Port Tampa Bay Cruise Terminals and Aquarium", "Raymond James Stadium", "Tropicana Field", "Weekiwachee Gardens and Wildlife Areas")) %>%
  pivot_longer(cols=3:12, names_to = "POI", values_to = "POI_TRUE_FALSE") %>%
  filter(POI_TRUE_FALSE==TRUE) %>%
  mutate(geo=as.character(geo),
         vehicle_type=case_when(vehicle_type=="HEAVY_COMMERCIAL" ~ "Heavy",vehicle_type=="MEDIUM_COMMERCIAL" ~ "Medium")) %>%
  pivot_longer(cols=2:4, names_to='category', values_to = "category_value") %>%
  pivot_longer(cols=2:5, names_to='trips_vmt_cat', values_to = "value") %>%
  mutate(trips_or_vmt=case_when(trips_vmt_cat %in% c("trips_origin","trips_destination") ~ "trips",
                                trips_vmt_cat %in% c("vmt_origin","vmt_destination") ~ "vmt"))

tod_all_final <- bind_rows(tod_22,tod_19) %>%
  rename_at(vars(poi_1:poi_10), ~ c("Downtown Tampa", "Busch Gardens", "Clear Water Beach",
                                    "Crystal River Wildlife Areas", "Downtown St Petersburg", "Hernando Beach",
                                    "Port Tampa Bay Cruise Terminals and Aquarium", "Raymond James Stadium", "Tropicana Field", "Weekiwachee Gardens and Wildlife Areas")) %>%
  pivot_longer(cols=2:11, names_to = "POI", values_to = "POI_TRUE_FALSE") %>%
  filter(POI_TRUE_FALSE==TRUE) %>%
  pivot_longer(cols=1:4, names_to='category', values_to = "category_value")

write_parquet(tod_all_final, "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\reid_data\\tod_all.parquet")

write_parquet(trip_all_final, "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\reid_data\\trip_all.parquet")

# library(tigris)
# library(geojsonio)
# states<-states(cb=T)
# states<-states %>% filter(!NAME %in% c("Puerto Rico","Alaska","Hawaii","Guam","Commonwealth of the Northern Mariana Islands","American Samoa","United States Virgin Islands"))
# 
# megaregion <- states %>% filter(NAME %in% c("Florida","Georgia","South Carolina")) %>% summarise()
# 
# geojson_write(megaregion,geometry="polygon", file="data/gis/megaregion.geojson")
# 
# geojson_write(states,geometry="polygon", file="data/gis/states.geojson")


## service population

vis_count <- read_csv("data/service_population/total_visitor_counts.csv") %>%
  pivot_longer(cols=2:3, names_to="year", values_to = "count") %>% 
  rename(POI=`...1`) %>%
  mutate(person_type="visitor")
service_pop<-bind_rows(
read_csv("data/service_population/service_population_2019.csv") %>% mutate(year='2019'),
read_csv("data/service_population/service_population_2022.csv") %>% mutate(year='2022')
) %>%
  pivot_longer(cols=2:3, names_to = "person_type", values_to = "count") %>% 
  rename(POI=POI_Description) %>%
  select(-POI_ID)
service_pop <-bind_rows(service_pop, vis_count)

write_parquet(service_pop, "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\service_pop.parquet")

### spending

  
### GIS ########
library(tigris)
library(geojsonio)
  #
county<-counties(cb=T)
  #
geojson_write(county,geometry="polygon", file="data/gis/county.geojson")

tract<-tracts(cb=T) %>%
  left_join(spend_tract %>% distinct(geoid) %>%mutate(geoid=as.character(geoid), data='yes'), by=c("GEOID"='geoid')) %>%
  filter(!is.na(data)) %>%
  st_centroid()

tracts<-tracts(cb=T, state="FL")

geojson_write(tracts,geometry="point", file="data/gis/tracts_FL.geojson")

geojson_write(tract,geometry="point", file="data/gis/tract_spend_point.geojson")

geojson_write(st_centroid(county),geometry="polygon", file="data/gis/county_point.geojson")

states<-states(cb=T)
states<-states %>% filter(!NAME %in% c("Puerto Rico","Alaska","Hawaii","Guam","Commonwealth of the Northern Mariana Islands","American Samoa","United States Virgin Islands"))

megaregion <- states %>% filter(NAME %in% c("Florida","Georgia","South Carolina")) %>% summarise()

geojson_write(megaregion,geometry="polygon", file="data/gis/megaregion.geojson")

geojson_write(states,geometry="polygon", file="data/gis/states.geojson")


###### visitor locations (trips)

vis_home_loc_basic <- bind_rows(
  # read_csv("data/visitor_data/replica/combined_home_locations_only_non_d7.csv"),
  read_csv("data/visitor_data/replica/combined_home_locations_excl_poi_res_and_wkr.csv") 
)

vis_d7<-st_join(vis_home_loc_df %>%
                  filter(!is.na(INTPTLAT)) %>%
                  st_as_sf(crs=4326, coords=c("INTPTLON","INTPTLAT")),
                gis_d7) %>%
  data.frame() %>%
  filter(d7=="yes") %>%
  pull(home_placename)


vis_home_loc_df <- vis_home_loc_basic %>%
  ungroup() %>%
  pivot_longer(cols=5:6, names_to = "year", values_to = "count") %>%
  mutate(loc_cat= case_when(home_placename %in% vis_d7 ~ "Inside District 7",
                            home_placename =='Outside megaregion' ~'Outside megaregion',
                            TRUE ~ as.character('Outside District 7')))




# vis_home_loc_sf <- vis_home_loc_basic %>% 
#   filter(!is.na(INTPTLAT)) %>%
#   st_as_sf(crs=4326,coords=c("INTPTLON","INTPTLAT"))

# vis_bg<-st_join(gis_BG, vis_home_loc_sf) %>% data.frame() %>%
#   group_by(FIPS_bgrp) %>%
#   summarise(`2019`=sum(`X2019`,na.rm=T),
#             `2022`=sum(`X2022`,na.rm=T))
# vis_bg_sf <- gis_BG %>%
#   left_join(vis_bg, by="FIPS_bgrp")

#saveRDS(vis_bg_sf, file = "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\vis_bg_sf.rds")

#saveRDS(vis_home_loc_sf, file = "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\vis_home_loc_sf.rds")

write_parquet(vis_home_loc_df, "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\vis_home_loc_df.parquet")

vis_attributes <- bind_rows(
  bind_rows(
    read_csv("data/visitor_data/replica/combined_hh_income_excl_poi_res_and_wkr.csv")#,
    #read_csv("data/visitor_data/replica/combined_hh_income_only_non_d7.csv") 
  ) %>%
    pivot_longer(cols=3:4, values_to = "count", names_to = "year")%>%
    pivot_longer(cols=2, values_to = "value", names_to = "metric"),
  bind_rows(
    read_csv("data/visitor_data/replica/combined_hh_sizes_excl_poi_res_and_wkr.csv")#,
    #read_csv("data/visitor_data/replica/combined_hh_sizes_only_non_d7.csv") 
  ) %>%
    pivot_longer(cols=3:4, values_to = "count", names_to = "year")%>%
    pivot_longer(cols=2, values_to = "value", names_to = "metric"),
  bind_rows(
    read_csv("data/visitor_data/replica/combined_trip_purposes_excl_poi_res_and_wkr.csv")#,
    # read_csv("data/visitor_data/replica/combined_trip_purposes_only_non_d7.csv") 
  ) %>%
    pivot_longer(cols=3:4, values_to = "count", names_to = "year")%>%
    pivot_longer(cols=2, values_to = "value", names_to = "metric")
) %>%
  rename(POI=`...1`)

write_parquet(vis_attributes, "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\vis_loc_attributes.parquet")

#### workers

poi_ref<- readRDS(file.path(SYSTEM_INPUT_GIS_DATA_PATH, "gis_POI.rds")) %>% data.frame() %>%
  rename(poi_name=POI_Description,poi_no=POI_ID) %>% select(-geom) %>%
  mutate(poi_no=as.character(poi_no))

worker_home_loc <- bind_rows(
  read_csv("data\\workers\\2022\\home_location_by_poi.csv") %>% mutate(year="2022") %>% mutate(TRACT=as.character(TRACT)),
  read_csv("data\\workers\\2019\\home_location_by_poi.csv") %>% mutate(year="2019")
) %>% mutate(work_poi=as.character(work_poi)) %>%
  left_join(poi_ref, by=c("work_poi"="poi_no")) %>%
  rowwise() %>%
  mutate(count=sum(c(`d7 resident work inside`,`d7 resident work outside`,`d7 worker live outside`),na.rm=T))

workers_emp_status<- bind_rows(
  read_csv("data\\workers\\2022\\emp_status.csv") %>% mutate(year="2022"),
  read_csv("data\\workers\\2019\\emp_status.csv") %>% mutate(year="2019")
) %>%
  pivot_longer(cols ="wfh" , names_to = "metric",values_to = "value") %>%
  rowwise() %>%
  mutate(count=sum(c(`d7 resident work inside`,`d7 resident work outside`,`d7 worker live outside`),na.rm=T))

workers_mode<- bind_rows(
  read_csv("data\\workers\\2022\\commute_mode.csv") %>% mutate(year="2022"),
  read_csv("data\\workers\\2019\\commute_mode.csv") %>% mutate(year="2019")
) %>%
  pivot_longer(cols ="commute_mode" , names_to = "metric",values_to = "value") %>%
  rowwise() %>%
  mutate(count=sum(c(`d7 resident work inside`,`d7 resident work outside`,`d7 worker live outside`),na.rm=T))

workers_inc<- bind_rows(
  read_csv("data\\workers\\2022\\inc.csv") %>% mutate(year="2022"),
  read_csv("data\\workers\\2019\\inc.csv") %>% mutate(year="2019")
)%>%
  pivot_longer(cols ="household_income_group" , names_to = "metric",values_to = "value") %>%
  rowwise() %>%
  mutate(count=sum(c(`d7 resident work inside`,`d7 resident work outside`,`d7 worker live outside`),na.rm=T))

workers_data <- bind_rows(workers_emp_status,workers_mode,workers_inc) %>%
  left_join(poi_ref, by=c("work_poi"="poi_no")) 

write_parquet(workers_data, "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\worker_loc_attributes.parquet")

write_parquet(worker_home_loc, "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\worker_home_locations.parquet") 


## resident

poi_ref<- readRDS(file.path(SYSTEM_INPUT_GIS_DATA_PATH, "gis_POI.rds")) %>% data.frame() %>%
  rename(poi_name=POI_Description,poi_no=POI_ID) %>% select(-geom) %>%
  mutate(poi_no=as.character(poi_no))

res_work_loc <- bind_rows(
  read_csv("data\\residents\\2022\\work_location_by_poi.csv") %>% mutate(year="2022"),
  read_csv("data\\residents\\2019\\work_location_by_poi.csv") %>% mutate(year="2019")
) %>% mutate(home_poi=as.character(home_poi)) %>%
  left_join(poi_ref, by=c("home_poi"="poi_no")) %>%
  rowwise() %>%
  mutate(count=sum(c(`d7 resident work inside`,`d7 resident work outside`),na.rm=T))

res_emp_status<- bind_rows(
  read_csv("data\\residents\\2022\\emp_status.csv") %>% mutate(year="2022"),
  read_csv("data\\residents\\2019\\emp_status.csv") %>% mutate(year="2019")
) %>%
  pivot_longer(cols ="wfh" , names_to = "metric",values_to = "value")

res_mode<- bind_rows(
  read_csv("data\\residents\\2022\\commute_mode.csv") %>% mutate(year="2022"),
  read_csv("data\\residents\\2019\\commute_mode.csv") %>% mutate(year="2019")
) %>%
  pivot_longer(cols ="commute_mode" , names_to = "metric",values_to = "value")

res_auto_own<- bind_rows(
  read_csv("data\\residents\\2022\\auto_ownership.csv") %>% mutate(year="2022"),
  read_csv("data\\residents\\2019\\auto_ownership.csv") %>% mutate(year="2019")
) %>%
  pivot_longer(cols ="vehicles" , names_to = "metric",values_to = "value")

res_hh_size<- bind_rows(
  read_csv("data\\residents\\2022\\hh_size.csv") %>% mutate(year="2022"),
  read_csv("data\\residents\\2019\\hh_size.csv") %>% mutate(year="2019")
)%>%
  pivot_longer(cols ="household_size" , names_to = "metric",values_to = "value")

res_inc<- bind_rows(
  read_csv("data\\residents\\2022\\inc.csv") %>% mutate(year="2022"),
  read_csv("data\\residents\\2019\\inc.csv") %>% mutate(year="2019")
)%>%
  pivot_longer(cols ="household_income_group" , names_to = "metric",values_to = "value")

res_data <- bind_rows(res_emp_status,res_mode,res_auto_own, res_hh_size,res_inc) %>%
  left_join(poi_ref, by=c("home_poi"="poi_no")) %>%
  rowwise() %>%
  mutate(count=sum(c(`d7 resident work inside`,`d7 resident work outside`),na.rm=T))

write_parquet(res_data, "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\res_loc_attributes.parquet")

write_parquet(res_work_loc, "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\res_work_locations.parquet") 


### service population

serv_pop<-read_excel("data/TampaSurvey_ServicePopulation_Summary.xlsx", sheet="serv_pop1") %>%
  pivot_longer(cols=3:5, names_to='category', values_to = "count") %>% select(-c(`Total Service Population`,`POI ID`)) %>% mutate(cat2="service_pop") %>%
  rename(POI=`POI Name`) 

lu<-read_excel("data/TampaSurvey_ServicePopulation_Summary.xlsx", sheet="serv_pop2") %>%
  pivot_longer(cols=2:4, names_to='category', values_to = "count") %>%  mutate(cat2="land_use")

lu2<-read_excel("data/TampaSurvey_ServicePopulation_Summary.xlsx", sheet="serv_pop3") %>%
  pivot_longer(cols=2:12, names_to='POI', values_to = "count") %>% 
  rename(category=land_use, cat2=residential) %>%
  select(POI, category, count,cat2) %>%
  mutate(cat2 = case_when(cat2=="yes"~ "res_info",
                          TRUE ~ as.character("commercial_info")))

serv_pop_lu<-bind_rows(serv_pop,lu,lu2
)

write_parquet(serv_pop_lu, "C:\\Users\\reid.haefer\\tampa\\tampa_mobility\\dashboard\\data\\serv_pop_lu.parquet") 

