
options_Trip = list(pageLength = 10, scrollX = FALSE, fixedColumns = FALSE, paging = FALSE, searching = FALSE, autoWidth = FALSE, ordering = FALSE, #dom = 'Bfrtp', #,
                    columnDefs = list(
                      list(className = 'dt-center', targets = "_all" ),
                      list(className = 'dt-left', targets = 0)
                    ),
                    initComplete = JS(
                      "function(settings, json) {",
                      "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                      "}"),
                    buttons = c('copy', 'csv', 'excel', 'print')) # I('colvis'),

renderTrip_dt = function(data, ...) {
  renderDT(data, class = "cell-border strip", rownames = FALSE, server = FALSE, extensions = 'Buttons', options = options_Trip) 
}

observeEvent(input$trip_year,{
  map_trip_zone_interest_fun(sel_year = input$trip_year )
  renderTable_TripGen_Purpose(sel_year = input$trip_year)
  cat("\n....... observe new trip_year:", input$trip_year, ".........\n")
})

observeEvent(input$trip_zone,{
  map_trip_zone_interest_fun(sel_zone = input$trip_zone )
  renderTable_TripGen_Purpose(sel_zone = input$trip_zone)
  cat("\n....... observe new trip_zone:", input$trip_zone, ".........\n")
})

observeEvent(input$trip_purpose,{
  renderTable_TripGen_Purpose(sel_purpose = input$trip_purpose)
  cat("\n....... observe new sel_purpose:", input$trip_purpose, ".........\n")
})

# function to render Trip table --
renderTable_TripGen_Purpose = function(sel_year, sel_zone, sel_purpose){
   # sel_year = trip_year_choices[1]; sel_zone = trip_zone_choices[1]; sel_purpose = trip_purpose_choices[1]
  sel_year = input$trip_year
  sel_zone = input$trip_zone
  sel_purpose = input$trip_purpose  
  
  sel_purpose_short = trip_purpose_choices_list[names(trip_purpose_choices_list) %in% sel_purpose][[1]] 
  if(sel_zone == "Tropicana Field") {sel_zone = "Tropicana Stadium"}
  if(sel_zone == "Clearwater Beach") {sel_zone = "Clear Water Beach"}
  
  # for trip generation table  ------------------
  trip_category_DT = APP_INPUT_TRIP_CATEGORY_FILELIST[[which(parse_number(names(APP_INPUT_TRIP_CATEGORY_FILELIST)) %in% sel_year)]]
  trip_category_DT = trip_category_DT[trip_category_DT[["area"]] %in% sel_zone,]  
  trip_category_long = data.table::melt(trip_category_DT, id.vars = c("trip_cat"),
                                              measure = c("person_trips", "vehicle_trips"),
                                              variable.name = "Type", value.name = "Trips")
  trip_category_long = trip_category_long %>% group_by(Type) %>%
    mutate(Share = Trips/sum(Trips))
  trip_category_long = data.table(trip_category_long)
  
  trip_category_label_within = paste0("Trips generated within ", sel_zone)
  trip_category_label_from   = paste0("Trips generated from ", sel_zone)
  trip_category_label_to     = paste0("Trips generated to ", sel_zone)
  trip_category_label_pass   = paste0("Trips passthrough ", sel_zone)
  
  trip_category_long[["trip_cat"]][trip_category_long[["trip_cat"]] %in% "within_poi"] = trip_category_label_within
  trip_category_long[["trip_cat"]][trip_category_long[["trip_cat"]] %in% "from_poi"] = trip_category_label_from
  trip_category_long[["trip_cat"]][trip_category_long[["trip_cat"]] %in% "to_poi"] = trip_category_label_to
  trip_category_long[["trip_cat"]][trip_category_long[["trip_cat"]] %in% "passthrough_poi"] = trip_category_label_pass  
  trip_category_long[["Type"]] = gsub("_trips", "", trip_category_long[["Type"]])
  trip_category_long_bar <- trip_category_long  
  trip_category_long[["trip_cat"]][trip_category_long[["Type"]] %like% "person"] = paste0("Person ", trip_category_long[["trip_cat"]][which(trip_category_long[["Type"]] %like% "person")] )
  trip_category_long[["trip_cat"]][trip_category_long[["Type"]] %like% "vehicle"] = paste0("Vehcile ", trip_category_long[["trip_cat"]][which(trip_category_long[["Type"]] %like% "vehicle")])
  trip_category_long = trip_category_long[, -c("Type")]  
  trip_category_long[["Share"]] = percent(trip_category_long[["Share"]], 0.1)
  names(trip_category_long)[1] = "Trip Category"
  # cat("\n....... trip_category_long  .........\n")
  # print(head(trip_category_long))
  
  output$trip_gen_table = renderTrip_dt(data.frame(trip_category_long))
  
  # for plot_bar_category_gen chart
  trip_category_long_bar[["trip_cat"]][trip_category_long_bar[["trip_cat"]] %like% " within "] = "Within"
  trip_category_long_bar[["trip_cat"]][trip_category_long_bar[["trip_cat"]] %like% " from "] = "From"
  trip_category_long_bar[["trip_cat"]][trip_category_long_bar[["trip_cat"]] %like% " to "] = "To"
  trip_category_long_bar[["trip_cat"]][trip_category_long_bar[["trip_cat"]] %like% " passthrough"] = "Passthrough"
  
  output$plot_bar_category_gen <- renderPlotly({
    ggplotly(
      trip_category_long_bar %>% 
        plot_ly(x = ~ trip_cat, y = ~ Trips, type = 'bar', color = ~ Type,
                colors = c(person = "#f07167", vehicle="#0081a7")) %>%
        layout(yaxis = list(title = 'Trips'), 
               xaxis = list(title = 'Trip Type Profile'), barmode = 'group')
    )
  })
  
  # for Purpose table ------------------
  trip_purpose_DT = APP_INPUT_TRIP_PURPOSE_FILELIST[[which(parse_number(names(APP_INPUT_TRIP_PURPOSE_FILELIST)) %in% sel_year)]]
  trip_purpose_DT = trip_purpose_DT[trip_purpose_DT[["area"]] %in% sel_zone,]  
  trip_purpose_long = data.table::melt(trip_purpose_DT, id.vars = c("purpose"),
                                             measure = c("person_trips", "vehicle_trips"),
                                             variable.name = "Type", value.name = "Trips")  
  trip_purpose_long = trip_purpose_long %>% group_by(Type) %>% mutate(Share = Trips/sum(Trips))
  trip_purpose_long = data.table(trip_purpose_long)  
  trip_purpose_long[["Share"]] = percent(trip_purpose_long[["Share"]], 0.1)
  trip_purpose_long[["Type"]]  = as.character(trip_purpose_long[["Type"]])
  trip_purpose_long[["Type"]][trip_purpose_long[["Type"]] %in% "person_trips"] = "person"
  trip_purpose_long[["Type"]][trip_purpose_long[["Type"]] %in% "vehicle_trips"] = "vehicle"
  
  output$plot_bar_purpose <- renderPlotly({
    ggplotly(
      trip_purpose_long %>% 
        plot_ly(y = ~ purpose, x = ~ Trips, type = 'bar', color = ~ Type,
                colors = c(person = "#ced4da", vehicle="#355070"),
                orientation = 'h')  %>%
        layout(xaxis = list(title = 'Trips'), 
               yaxis = list(title = 'Trip Purpose'), barmode = 'group')
    )
  })
  
  output$purpose_txtOutput = renderText({
    HTML(paste("nhbw: NonHome-Based Work" , "nhbo: NonHome-Based Other", "hbw: Home-Based Work", "hbo: Home-Based Other", sep ="\n"))
  })  
  
  # for TOD table  ------------------
  trip_TOD_DT = APP_INPUT_TRIP_TOD_FILELIST[[which(parse_number(names(APP_INPUT_TRIP_TOD_FILELIST)) %in% sel_year)]]
  trip_TOD_DT = trip_TOD_DT[trip_TOD_DT[["area"]] %in% sel_zone,]
  
  time_bin_list = sort(unique(trip_TOD_DT[["time_bin"]]))
  AM_bin = time_bin_list[time_bin_list>=6.0 & time_bin_list<10.0]
  MD_bin = time_bin_list[time_bin_list>=10.0 & time_bin_list<15.0]
  PM_bin = time_bin_list[time_bin_list>=15.0 & time_bin_list<19.0]
  NT_bin = time_bin_list[time_bin_list>=19.0 & time_bin_list<24 | time_bin_list>=0.0 & time_bin_list<6.0]
  
  trip_TOD_DT$tod = "AM"
  trip_TOD_DT$tod[trip_TOD_DT[["time_bin"]] %in% MD_bin] = "MD"
  trip_TOD_DT$tod[trip_TOD_DT[["time_bin"]] %in% PM_bin] = "PM"
  trip_TOD_DT$tod[trip_TOD_DT[["time_bin"]] %in% NT_bin] = "NT"
  
  # for chart - hourly distribution
  trip_TOD_DT_chart = trip_TOD_DT[trip_TOD_DT[["purpose"]] %in% sel_purpose_short,]
  
  output$plot_time_period <- renderPlotly({
    ggplotly(
      trip_TOD_DT_chart %>% 
        plot_ly(y = ~ person_trips, x = ~ time_bin, name = "person", type = 'scatter', mode = "lines", line = list(color = '#f3722c'))  %>%
        add_trace(y = ~vehicle_trips, name = 'vehicle', line = list(color = '#2c6e49')) %>%
        layout(yaxis = list(title = 'Trips'), 
               xaxis = list(title = 'Hour'),
               title = paste0('Daily Trip Distribution : ', sel_purpose))
    )
  })
  
  # for tod-level summary
  trip_TOD_DT_sum <- trip_TOD_DT_chart[ , .(person_trips  = sum(person_trips),
                                            vehicle_trips = sum(vehicle_trips)), by = list(tod)]  
  
  trip_TOD_DT_sum = trip_TOD_DT_sum %>% mutate(person_share = person_trips/sum(person_trips),
                                               vehicle_share := vehicle_trips/sum(vehicle_trips))
  trip_TOD_DT_sum = data.table(trip_TOD_DT_sum)
  trip_TOD_DT_sum[["person_share"]] = percent(trip_TOD_DT_sum[["person_share"]], 0.1)
  trip_TOD_DT_sum[["vehicle_share"]] = percent(trip_TOD_DT_sum[["vehicle_share"]], 0.1)
  
  output$TOD_txtOutput = renderText({
    HTML(paste(
      paste0("Percent of Person Trips Generated in the AM Peak Period: ", trip_TOD_DT_sum[["person_share"]][trip_TOD_DT_sum[["tod"]] %in% "AM"]),
      paste0("Percent of Person Trips Generated in the PM Peak Period: ", trip_TOD_DT_sum[["person_share"]][trip_TOD_DT_sum[["tod"]] %in% "PM"]),
      paste0("Percent of Vehicle Trips Generated in the AM Peak Period: ", trip_TOD_DT_sum[["vehicle_share"]][trip_TOD_DT_sum[["tod"]] %in% "AM"]),
      paste0("Percent of Vehicle Trips Generated in the PM Peak Period: ", trip_TOD_DT_sum[["vehicle_share"]][trip_TOD_DT_sum[["tod"]] %in% "PM"]), sep ="\n"))
  })
  
  # output$trip_TOD_table = renderTrip_dt(data.frame(trip_TOD_DT_sum))
  
  # for Trip Length table  ------------------
  trip_distance_DT = APP_INPUT_TRIP_DISTANCE_FILELIST[[which(parse_number(names(APP_INPUT_TRIP_DISTANCE_FILELIST)) %in% sel_year)]]
  trip_distance_DT = trip_distance_DT[trip_distance_DT[["area"]] %in% sel_zone,]
  trip_distance_DT = trip_distance_DT[trip_distance_DT[["purpose"]] %in% sel_purpose_short,]  
  # dist_bin_list = sort(unique(trip_distance_DT[["dist_bin"]]))
  x_label = c("<2 miles", "2-4 miles", "4-6 miles", "6-10 miles", "10-20 miles", "20-30 miles", "30-40 miles", "40-50 miles", ">50 miles")
  
  for(i in 1:length(dist_bin_list)){
    trip_distance_DT$dist[trip_distance_DT$dist_bin %in% dist_bin_list[[i]]] = x_label[i]
  }
  
  trip_distance_long = data.table::melt(trip_distance_DT, id.vars = c("dist"),
                                       measure = c("person_trips", "vehicle_trips"),
                                       variable.name = "Type", value.name = "Trips")  
  trip_distance_long[["Type"]] = as.character(trip_distance_long[["Type"]] )
  trip_distance_long[["Type"]][trip_distance_long[["Type"]] %in% "person_trips"] = "person"
  trip_distance_long[["Type"]][trip_distance_long[["Type"]] %in% "vehicle_trips"] = "vehicle"
  
  trip_distance_long = trip_distance_long[ , lapply(.SD, sum), by=c("dist", "Type"), .SDcols = "Trips"]
  
  trip_distance_long$dist <- factor(trip_distance_long$dist, levels = x_label)
  
  # for chart - hourly distribution
  output$plot_distance <- renderPlotly({
    ggplotly(
      trip_distance_long %>% 
        plot_ly(x = ~ dist, y = ~ Trips, type = 'bar', color = ~ Type,
                colors = c(person = "#f07167", vehicle="#0081a7")) %>%
        layout(yaxis = list(title = 'Trips'), 
               xaxis = list(title = 'Distance'),
               title = paste0('Person Trips by Trip Length Bin : ', sel_purpose))
      , barmode = 'group'
    )
  })
  

  if(sel_year == 2019) {
    sel_tot_vmt = vmt_per_capita_2019$total_miles[vmt_per_capita_2019$area %in% sel_zone]    
    sel_vmt_per_capita = vmt_per_capita_2019$vmt_per_capita[vmt_per_capita_2019$area %in% sel_zone]  
  } else {
    sel_tot_vmt = vmt_per_capita_2022$total_miles[vmt_per_capita_2022$area %in% sel_zone]    
    sel_vmt_per_capita = vmt_per_capita_2022$vmt_per_capita[vmt_per_capita_2022$area %in% sel_zone]  
  }

  output$VMT_txtOutput = renderText({
    HTML(paste(
      paste0("Total Vehicle Miles Travelled Generated (for ", sel_year, " ): ", prettyNum(round(sel_tot_vmt,0), big.mark = ",")),
      paste0("Vehicle Miles Travelled Per Population (for ", sel_year, " ): ", prettyNum(round(sel_vmt_per_capita,0), big.mark = ",")), sep ="\n"))
  })
  
}

# function to render area (zone) map -----
map_trip_zone_interest_fun = function(sel_year, sel_zone){
  # sel_year = trip_year_choices[1]; sel_zone = trip_zone_choices[9]
  sel_year = input$trip_year
  sel_zone = input$trip_zone

  # setView by sel_zone
  sel_lon = poi_latlon[[2]][poi_latlon$poi_name %in% sel_zone]
  sel_lat = poi_latlon[[3]][poi_latlon$poi_name %in% sel_zone]
  sel_zoom = 11
  
  sel_zone_raw = sel_zone
  if(sel_zone_raw == "Tropicana Field") {sel_zone_raw = "Tropicana Stadium"}
  if(sel_zone_raw == "Clearwater Beach") {sel_zone_raw = "Clear Water Beach"}
  
  # for trip generation table
  # unique(trip_category_DT$area)
  trip_category_DT    = APP_INPUT_TRIP_CATEGORY_FILELIST[[which(parse_number(names(APP_INPUT_TRIP_CATEGORY_FILELIST)) %in% sel_year)]]
  trip_category_DT    = trip_category_DT[trip_category_DT[["area"]] %in% sel_zone_raw,]
  
  sel_gis_POI = gis_POI[gis_POI[["POI_Description"]] %in% trip_category_DT[["area"]],]
  trip_distance_wide = dcast(trip_category_DT, area ~ trip_cat, value.var = c("person_trips", "vehicle_trips"))
  sel_gis_POI = merge(sel_gis_POI, trip_distance_wide, by = 'POI_Description', by.y  = 'area')
  
  # map_trip_zone_interest ----------------
  map_trip_interest_loads <- reactive({
    
    leaflet() %>%
      addTiles(group = "OSM") %>%
      addProviderTiles(providers$CartoDB.Positron, group ="CartoDB.Positron") %>%
      addProviderTiles(providers$Stamen.TonerLite, group = "TonerLite", options = providerTileOptions(noWrap = TRUE)) %>%
      
      addPolygons(
        data = sel_gis_POI,
        fillColor = ~ "orange",
        fillOpacity = 0.5,
        color = "#0077b6",
        weight = 1,
        stroke = TRUE,
        # opacity = 0.5,
        layerId = ~ POI_ID,
        label = ~ POI_Description
      ) %>%
      
      addLayersControl(baseGroups = c("TonerLite", "CartoDB.Positron", "OSM"),
                       position = "topright",
                       options = layersControlOptions(collapOD = TRUE)) 
  })
  
  output$map_trip_zone_interest <- renderLeaflet({
    map_trip_interest_loads()
  })
  # rm(trip_category_DT)
}
