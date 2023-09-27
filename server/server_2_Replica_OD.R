 
# sel_od_traveler_type = od_traveler_type_choices[1]; sel_od_traveler_type
# sel_od_selection = od_selection_choices[1]; sel_od_selection

output$map_trip_compare_od <- renderLeaflet({
  req(input$od_traveler_type);req(input$od_selection); req(APP_INPUT_REPLICA_OD_DATA_2022); req(gis_TAZ); # req(input$od_purpose); 
  sel_od_traveler_type = input$od_traveler_type
  sel_od_selection     = input$od_selection
  # sel_od_purpose_short = trip_purpose_choices_list[names(trip_purpose_choices_list) %in% sel_od_purpose][[1]]  
  
  sel_Replica_OD_2022 <- APP_INPUT_REPLICA_OD_DATA_2022[[which(names(APP_INPUT_REPLICA_OD_DATA_2022) %in% sel_od_selection)]]
  sel_Replica_OD_2022 <- sel_Replica_OD_2022[[which(names(sel_Replica_OD_2022) %in% sel_od_traveler_type)]]
  sel_Replica_OD_2022 = sel_Replica_OD_2022[!is.na(sel_Replica_OD_2022$trips),]
  
  sel_Replica_OD_2022_df = st_drop_geometry(sel_Replica_OD_2022)
  sel_colorpal_zone <- APP_INPUT_REPLICA_OD_COLORPAL_2022[[which(names(APP_INPUT_REPLICA_OD_COLORPAL_2022) %in% sel_od_selection)]]
  sel_colorpal_zone <- sel_colorpal_zone[[which(names(sel_colorpal_zone) %in% sel_od_traveler_type)]]
  
  od_map_header_text <- reactive({
    ifelse(sel_od_selection == "Origin", "Trips generated from zone" , "Trips ended to zone")
  })
  
  output$od_map_header <- renderText(od_map_header_text()) 
  
  gis_TAZ = gis_TAZ[gis_TAZ$zone %in% sel_Replica_OD_2022$zone,]
  # map trip comparison originated from zone -------------
  
  leaflet() %>%
    addTiles(group = "OSM") %>%
    addProviderTiles(providers$CartoDB.Positron, group ="CartoDB.Positron") %>%
    addProviderTiles(providers$Stamen.TonerLite, group = "TonerLite", options = providerTileOptions(noWrap = TRUE)) %>%
    
    addPolygons(
      data = sel_Replica_OD_2022,
      fillColor = ~sel_colorpal_zone(sel_Replica_OD_2022_df$trips),
      fillOpacity = 0.8,
      color = "#edf6f9",
      weight = 1,
      stroke = TRUE,
      opacity = 0.5,
      layerId = ~ zone,
      group = "ZONE_OD",
      # label = ~trips,
      highlight = highlightOptions(
        weight = 2, color = 'red', fillOpacity = 0.7, bringToFront = TRUE),
      label = mapply(function(a, b) {
        htmltools::HTML(sprintf("<strong>Zone: %s</strong> <br/> Trips: %s",
                                htmlEscape(a), htmlEscape(b)))
      }, sel_Replica_OD_2022_df$zone, sel_Replica_OD_2022_df$trips, SIMPLIFY = F)
      
    ) %>%
    
    addPolygons(
      data = gis_TAZ,
      fillOpacity = 0,
      color = "gray",
      opacity = 0.5,
      weight = 1,
      stroke = TRUE,
      layerId = ~ zone,
      group = "ZONE",
      label = ~zone,

    ) %>%
    
    showGroup(group = "ZONE_OD") %>%
    hideGroup(group = "ZONE") %>%
    addLayersControl(baseGroups = c("TonerLite", "OSM",  "CartoDB.Positron"),
                     position = "topright",
                     overlayGroups = c("ZONE_OD", "ZONE"),
                     options = layersControlOptions(collapOD = TRUE)) %>%
    
    setView(lng = -82.457176, lat = 27.950575, zoom = 10) %>%
    
    addLegend(data = sel_Replica_OD_2022_df,
              pal = sel_colorpal_zone, values = ~ trips, title = "Trips", 
              group = "ZONE_OD", position = "bottomright") 
  
})


output$od_chart_comparison <- renderPlotly({
  req(input$od_traveler_type);req(input$od_selection); req(APP_INPUT_RMERGE_OD_DATA_2019); req(APP_INPUT_REPLICA_OD_DATA_2022); req(gis_TAZ); # req(input$od_purpose); 
  sel_od_traveler_type = input$od_traveler_type
  sel_od_selection     = input$od_selection
  
  sel_Replica_OD_2022 <- APP_INPUT_REPLICA_OD_DATA_2022[[which(names(APP_INPUT_REPLICA_OD_DATA_2022) %in% sel_od_selection)]]
  sel_Replica_OD_2022 <- sel_Replica_OD_2022[[which(names(sel_Replica_OD_2022) %in% sel_od_traveler_type)]]
  sel_Replica_OD_2022_drop = data.table(st_drop_geometry(sel_Replica_OD_2022))
  sel_Replica_OD_2022_drop[, county:=NULL]
  
  APP_INPUT_RMERGE_OD_DATA_2019$trips = as.integer(APP_INPUT_RMERGE_OD_DATA_2019$trips)
  sel_Rmerge_OD_2019  <- APP_INPUT_RMERGE_OD_DATA_2019 %>% filter(type %in% sel_od_traveler_type & variable %in% sel_od_selection) # & purpose %in% sel_od_purpose_short 
  
  names(sel_Rmerge_OD_2019)[4] = "trips_2019"
  names(sel_Replica_OD_2022_drop)[4] = "trips_2022"
  RmergeReplica_OD_2019_22  <- right_join(sel_Rmerge_OD_2019[,-("year")], sel_Replica_OD_2022_drop[,-("year")], by = c("zone", "variable", "type"))
  
  RmergeReplica_OD_2019_22 = RmergeReplica_OD_2019_22[!is.na(RmergeReplica_OD_2019_22$zone),]
  RmergeReplica_OD_2019_22 = RmergeReplica_OD_2019_22[!is.na(RmergeReplica_OD_2019_22$type),]
  
  model <- lm(trips_2019 ~ trips_2022, data = RmergeReplica_OD_2019_22)
  
  ggplotly(
    RmergeReplica_OD_2019_22 %>%
      ggplot(aes(x = trips_2019, y = trips_2022))+
      geom_point(color = "orange", size = 1) +
      geom_smooth(method = 'lm', color = "grey20") +
      annotate("text", label=paste0("     R = ", round(with(RmergeReplica_OD_2019_22, cor.test(trips_2019, trips_2022))$estimate, 2)),
               x = min(RmergeReplica_OD_2019_22$trips_2019) + 1, y = max(RmergeReplica_OD_2019_22$trips_2022) + 1, color="steelblue", size=3) +
      scale_x_continuous("rMerge Trips 2019") +
      scale_y_continuous("Replica Trips 2022") +
      theme(
        axis.title.x = element_text(color = "grey20", size = 10, angle = 0, hjust = .5, vjust = 0, face = "plain"),
        axis.title.y = element_text(color = "grey20", size = 10, angle = 90, hjust = .5, vjust = .5, face = "plain"))
    
  )
  
})  

