output$comm_trip_type<-renderPlotly({
  ggplotly(
    trip_all %>% filter(POI_TRUE_FALSE == TRUE & year==input$year_comm & POI== input$select_zone_comm & category=="trip_type"& 
                          trips_or_vmt ==input$vmt_trips_comm) %>%
      group_by(category_value) %>%
      summarise(value=sum(value,na.rm=T)) %>%
      ggplot(aes(category_value, value)) + geom_col() + theme_minimal() + xlab("") + ylab("") 
  )
})

output$comm_vehicle_type<-renderPlotly({
  ggplotly(
    trip_all %>% filter(POI_TRUE_FALSE == TRUE & year==input$year_comm & POI== input$select_zone_comm & category=="vehicle_type"& 
                          trips_or_vmt ==input$vmt_trips_comm) %>%
      group_by(category_value) %>%
      summarise(value=sum(value,na.rm=T))
    %>%
      ggplot(aes(category_value, value)) + geom_col() + theme_minimal() + xlab("") + ylab("")
  )
})

output$comm_trip_length<-renderPlotly({
  ggplotly(
    trip_all %>% filter(POI_TRUE_FALSE == TRUE & year==input$year_comm & POI== input$select_zone_comm & category=="triplen_mi" & 
                          trips_or_vmt ==input$vmt_trips_comm) %>%
      group_by(category_value) %>%
      summarise(value=sum(value,na.rm=T)) %>%
      mutate(category_value=factor(category_value, levels=c("< 0.25 mi","0.25 - 0.5 mi","0.5 - 1 mi","1 - 2.5 mi","2.5 - 5 mi","5 - 10 mi","10 - 15 mi","15 - 30 mi","30 - 50 mi","50 - 100 mi","100 - 150 mi","> 150+ mi" ))) %>%
      ggplot(aes(category_value, value)) + geom_col() + theme_minimal() + xlab("") + ylab("") +coord_flip()
  )
})
map_data_comm<- reactive({
  com_veh_geo %>%
    left_join(
      trip_all %>% filter(POI_TRUE_FALSE == TRUE & year==input$year_comm & POI== input$select_zone_comm & trips_or_vmt ==input$vmt_trips_comm)%>% group_by(geo) %>%
        summarise(value=sum(value,na.rm=T)) , by=c("GEOID"="geo") 
    )%>% filter(!is.na(value))
})

gis_POI_react_comm<- reactive({
  gis_POI_D7 %>% filter(POI_Description == input$select_zone_comm)
})

output$map_comm_loc<-renderLeaflet({
  leaflet() %>% addProviderTiles(providers$CartoDB.Positron, group ="CartoDB.Positron") %>% 
    addCircles(data = map_data_comm(), radius = ~value, color = "red", weight = 0, fillOpacity = .4 ,group="Geographies", label= ~ map_data_comm()$GEOID,
               highlightOptions = highlightOptions(
                 color = "black",
                 weight=1,
                 fillOpacity = 0
               ))%>%
    addPolygons(data=gis_POI_react_comm(), color ="#04a99b", label= ~gis_POI_react_comm()$POI_Description, group="POI") %>%
    addLayersControl(baseGroups = c("CartoDB.Positron"),
                     position = "topright",
                     overlayGroups = c("Geographies","POI"),
                     options = layersControlOptions(collapOD = TRUE))
})
output$comm_vmt_tot<-renderValueBox({
  valueBox(
    value=trip_all %>% filter(POI_TRUE_FALSE == TRUE & year==input$year_comm & POI== input$select_zone_comm  & trips_or_vmt =='vmt') %>%
      summarise(value=prettyNum(round(sum(value,na.rm=T),0), big.mark = ",")) %>% pull(value), subtitle = "Total VMT", color="navy"
  )
})
output$comm_trips_tot<-renderValueBox({
  valueBox(
    value=trip_all %>% filter(POI_TRUE_FALSE == TRUE & year==input$year_comm & POI== input$select_zone_comm  & trips_or_vmt =='trips') %>%
      summarise(value=prettyNum(round(sum(value,na.rm=T),0), big.mark = ",")) %>% pull(value), subtitle = "Total Trips", color="navy"
  )
})
output$comm_tod<-renderPlotly({
  ggplotly(
    tod_all %>% filter(POI_TRUE_FALSE == TRUE & year==input$year_comm & POI== input$select_zone_comm & category=="15_min_bin") %>%
      group_by(category_value) %>%
      summarise(trips=sum(trips,na.rm=T)) %>%
      ggplot(aes(category_value, trips)) + geom_col() + theme_minimal() + xlab("") + ylab("") +
      theme(axis.text.x=element_text(size=6))
  )
})

