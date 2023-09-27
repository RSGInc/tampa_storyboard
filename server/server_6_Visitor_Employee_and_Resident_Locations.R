
vis_home_loc_df$POI[vis_home_loc_df$POI == "Tropicana Stadium"] = "Tropicana Field"
vis_attributes$POI[vis_attributes$POI == "Tropicana Stadium"] = "Tropicana Field"
res_work_loc$poi_name[res_work_loc$poi_name == "Tropicana Stadium"] = "Tropicana Field"
res_data$poi_name[res_data$poi_name == "Tropicana Stadium"] = "Tropicana Field"
worker_home_loc$poi_name[worker_home_loc$poi_name == "Tropicana Stadium"] = "Tropicana Field"
worker_data$poi_name[worker_data$poi_name == "Tropicana Stadium"] = "Tropicana Field"

vis_home_loc_df$POI[vis_home_loc_df$POI == "Clear Water Beach"] = "Clearwater Beach"
vis_attributes$POI[vis_attributes$POI == "Clear Water Beach"] = "Clearwater Beach"
res_work_loc$poi_name[res_work_loc$poi_name == "Clear Water Beach"] = "Clearwater Beach"
res_data$poi_name[res_data$poi_name == "Clear Water Beach"] = "Clearwater Beach"
worker_home_loc$poi_name[worker_home_loc$poi_name == "Clear Water Beach"] = "Clearwater Beach"
worker_data$poi_name[worker_data$poi_name == "Clear Water Beach"] = "Clearwater Beach"

#### visitor ######

vis <- reactive({
  vis_home_loc_df %>% filter(POI == input$select_zone_vis & year==input$year_vis)  %>%
    filter(!is.na(INTPTLAT)) %>%
    st_as_sf(crs=4326, coords=c("INTPTLON","INTPTLAT")) %>%
    filter(home_placename != "Tampa") ######## don't show Tampa because it overwhelms the map
})

gis_POI_react_vis<- reactive({
  gis_POI_D7 %>% filter(POI_Description == input$select_zone_vis)
})

### visitor ###

vis_map_label <- reactive({
  label_test<-paste0('<strong>', vis()$home_placename, '</strong>',
                    '<br/>', 'Visitor Home Location Count: ', '<strong>', vis()$count, '</strong>', ' ') %>% 
  lapply(htmltools::HTML)
})

pie_data<-reactive({
  vis_home_loc_df %>%
  filter(POI == input$select_zone_vis & year==input$year_vis) %>% 
  group_by(loc_cat) %>%
  summarise(count=sum(count)) %>%
  mutate(total=sum(count), percent=round((count/total * 100),0))
})


output$map_vis_loc <-renderLeaflet({
  leaflet() %>% addProviderTiles(providers$CartoDB.Positron, group ="CartoDB.Positron") %>%
    addCircles(data = vis(), radius = ~(10*count), color = "red", weight = 0, fillOpacity = .4,label= ~vis_map_label(),group="Visitor Home Locations",
               highlightOptions = highlightOptions(
                 color = "black",
                 weight=1,
                 fillOpacity = 0
               )) %>%
    addPolygons(data=gis_POI_react_vis(), color ="#04a99b",label= ~gis_POI_react_vis()$POI_Description, group="POI") %>%
    #showGroup(group = "ZONE_OD") %>%
    addLayersControl(baseGroups = c("CartoDB.Positron"),
                     position = "topright",
                     overlayGroups = c("Visitor Home Locations","POI"),
                     options = layersControlOptions(collapOD = TRUE))
})

output$vis_size<-renderPlotly({
  ggplotly(
    vis_attributes %>% filter(metric == 'household_size' & year==input$year_vis & POI== input$select_zone_vis) %>%
    ggplot(aes(value, count)) + geom_col() + theme_minimal() + xlab("") + ylab("") 
  )
})

output$vis_loc_cat<-renderPlotly({
  plot_ly(data=pie_data(),labels=~loc_cat, values=~percent, type="pie",marker = list(colors = c("#b1b1b1","#ba790a","#04a99b"))) %>% 
    layout(title = '',
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
})

output$vis_purpose<-renderPlotly({
  ggplotly(
    vis_attributes %>% filter(metric == 'purpose' & year==input$year_vis  & POI==input$select_zone_vis) %>%
      ggplot(aes(reorder(value, -count), count, text= paste(value,'</br>',
                                                            '</br>Trips: ', count))) + 
      geom_col() + theme_minimal() + xlab("") + ylab("") ,
    tooltip=c("text")
  )
})

output$work_trips_percent <- renderValueBox({
  valueBox(
    value=
      percent(
      vis_attributes %>% filter(metric=='purpose' & value %in% c('NHBW','HBW')& year==input$year_vis  & POI==input$select_zone_vis) %>% summarise(count=sum(count))/
      vis_attributes %>% filter(metric=='purpose'& year==input$year_vis  & POI==input$select_zone_vis) %>% summarise(count=sum(count))
      ), color="navy", subtitle = "Work Trips - Percent of All Trips"
  )
})
output$hbo_trips_percent <- renderValueBox({
  valueBox(
    value=
      percent(
        vis_attributes %>% filter(metric=='purpose' & value %in% c('HBO')& year==input$year_vis  & POI==input$select_zone_vis) %>% summarise(count=sum(count))/
          vis_attributes %>% filter(metric=='purpose'& year==input$year_vis  & POI==input$select_zone_vis) %>% summarise(count=sum(count))
      ), color="navy", subtitle = "Non Work Home Based Trips - Percent of All Trips"
  )
})
output$vis_income<-renderPlotly({
  ggplotly(
    vis_attributes %>% filter(metric == 'household_income' & year==input$year_vis & POI==input$select_zone_vis) %>%
      mutate(value=factor(value, levels=c("<$25k","$25k-$50k","$50k-$75k","$75k-$100k","$100k-$150k",'>$150k'))) %>%
      ggplot(aes(value, count)) + geom_col() + theme_minimal() + xlab("") + ylab("") 
  )
  })

########## resident ###########

res <- reactive({
 res_work_loc %>% filter(poi_name==input$select_zone_res& year==input$year_res) %>%
    st_as_sf(crs=4326, coords=c("longitude","latitude"))
})

res_map_label <- reactive({
  paste0('<strong>', res()$TRACT_work, '</strong>',
         '<br/>', 'Resident Work Location Count (Tract): ', '<strong>',res()$count, '</strong>', ' ') %>% 
    lapply(htmltools::HTML)
})

gis_POI_react_res<- reactive({
  gis_POI_D7 %>% filter(POI_Description == input$select_zone_res)
})

# pal_res_data <- reactive({
#   colorNumeric(palette = "viridis", domain = res_work_loc()$count)
# })
output$map_res_tract <-renderLeaflet({
  leaflet() %>% addProviderTiles(providers$CartoDB.Positron, group ="CartoDB.Positron") %>% 
    addCircles(data = res(), radius = ~(5*count), color = "red", weight = 0, fillOpacity = .4 ,label= ~res_map_label(), group="Resident Work Locations",
               highlightOptions = highlightOptions(
                 color = "black",
                 weight=1,
                 fillOpacity = 0
               ))%>%
    addPolygons(data=gis_POI_react_res(), color ="#04a99b", label= ~gis_POI_react_res()$POI_Description, group="POI") %>%
    addLayersControl(baseGroups = c("CartoDB.Positron"),
                     position = "topright",
                     overlayGroups = c("Resident Work Locations","POI"),
                     options = layersControlOptions(collapOD = TRUE))
})

output$res_emp<-renderPlotly({
  ggplotly(
    res_data %>% filter(metric == 'wfh' & poi_name==input$select_zone_res& year==input$year_res) %>%
      group_by(value) %>%
      summarise(count=sum(count,na.rm=T)) %>%
      mutate(value=case_when(value =="worked_from_home" ~ "Home",
                             value =="worked_in_person" ~ "In-Person")) %>%
      ggplot(aes(value, count)) + geom_col() + theme_minimal() + xlab("") + ylab("") 
  )
})

output$res_commute<-renderPlotly({
  ggplotly(
    res_data %>% filter(metric == 'commute_mode' & poi_name==input$select_zone_res& year==input$year_res) %>%
      group_by(value) %>%
      summarise(count=sum(count,na.rm=T)) %>%
      ggplot(aes(reorder(value, -count), count, text= paste(value,'</br>',
                                                            '</br>Trips: ', count))) + 
      geom_col() + theme_minimal() + xlab("") + ylab("") ,
    tooltip=c("text")
  )
})

output$res_vehicles<-renderPlotly({
  ggplotly(
    res_data %>% filter(metric == 'vehicles' & poi_name==input$select_zone_res& year==input$year_res) %>%
      group_by(value) %>%
      summarise(count=sum(count,na.rm=T)) %>%
      mutate(value=factor(value, levels=c("zero","1","2","3_plus","GQ"))) %>%
      ggplot(aes(value, count)) + geom_col() + theme_minimal()+ xlab("") + ylab("") 
  )
})

output$res_hh_size<-renderPlotly({
  ggplotly(
    res_data %>% filter(metric == 'household_size' & poi_name==input$select_zone_res & year==input$year_res) %>%
      group_by(value) %>%
      summarise(count=sum(count,na.rm=T)) %>%
      ggplot(aes(value, count)) + geom_col() + theme_minimal()+ xlab("") + ylab("") +  coord_flip()
  )
})

output$res_income<-renderPlotly({
  ggplotly(
    res_data %>% filter(metric == 'household_income_group' & poi_name==input$select_zone_res & year==input$year_res) %>%
      group_by(value) %>%
      summarise(count=sum(count,na.rm=T)) %>%
      mutate(value=factor(value, levels=c("lte_10000","10000_40000","40000_75000","75000_125000","125000_plus"),
                          labels=c("< $10k","$10-40k","$40-75k","$75-125k","> $125k"))) %>%
      ggplot(aes(value, count)) + geom_col() + theme_minimal() + xlab("") + ylab("") 
  )
})
######### worker ###########

worker_map_label <- reactive({
  paste0('<strong>', worker()$TRACT, '</strong>',
         '<br/>', 'Worker Home Location Count (Tract): ', '<strong>',worker()$count, '</strong>', ' ') %>% 
    lapply(htmltools::HTML)
})

worker <- reactive({
  worker_home_loc %>% filter(poi_name == input$select_zone_worker & year==input$year_worker) %>%
    st_as_sf(crs=4326, coords=c("longitude","latitude"))
})

gis_POI_react_worker<- reactive({
  gis_POI_D7 %>% filter(POI_Description == input$select_zone_worker)
})

output$map_worker_tract <-renderLeaflet({
  leaflet() %>% addProviderTiles(providers$CartoDB.Positron, group ="CartoDB.Positron") %>%
    addCircles(data = worker(), radius = ~(5*count), color = "red", weight = 0, fillOpacity = .4, label=worker_map_label(), group="Worker Home Locations",
               highlightOptions = highlightOptions(
                 color = "black",
                 weight=1,
                 fillOpacity = 0
               )) %>%
    addPolygons(data=gis_POI_react_worker(), color ="#04a99b", label= ~gis_POI_react_worker()$POI_Description, group="POI") %>%
    addLayersControl(baseGroups = c("CartoDB.Positron"),
                     position = "topright",
                     overlayGroups = c("Worker Home Locations","POI"),
                     options = layersControlOptions(collapOD = TRUE))
 
})

output$worker_emp<-renderPlotly({
  ggplotly(
    worker_data %>% filter(metric == 'wfh' & poi_name==input$select_zone_worker & year==input$year_worker) %>%
      group_by(value) %>%
      summarise(count=sum(count,na.rm=T)) %>%
      mutate(value=case_when(value =="worked_from_home" ~ "Home",
                             value =="worked_in_person" ~ "In-Person")) %>%
      ggplot(aes(value, count)) + geom_col() + theme_minimal() + xlab("") + ylab("")
  )
})
output$worker_commute<-renderPlotly({
  ggplotly(
    worker_data %>% filter(metric == 'commute_mode' & poi_name==input$select_zone_worker & year==input$year_worker) %>%
      group_by(value) %>%
      summarise(count=sum(count,na.rm=T)) %>%
      ggplot(aes(reorder(value, -count), count, text= paste(value,'</br>',
                                                            '</br>Trips: ', count))) +
      geom_col() + theme_minimal() + xlab("") + ylab(""),
    tooltip=c("text")
  )
})


output$worker_income<-renderPlotly({
  ggplotly(
    worker_data %>% filter(metric == 'household_income_group' & poi_name==input$select_zone_worker & year==input$year_worker) %>%
      group_by(value) %>%
      summarise(count=sum(count,na.rm=T)) %>%
      mutate(value=factor(value, levels=c("lte_10000","10000_40000","40000_75000","75000_125000","125000_plus"),
                          labels=c("< $10k","$10-40k","$40-75k","$75-125k","> $125k"))) %>%
      ggplot(aes(value, count)) + geom_col() + theme_minimal() + xlab("") + ylab("") 
  ) 
})

output$vis_lbs_tab_top_outside7 <- renderDataTable({
  datatable(
    vis_lbs_home_d7_state_df %>% filter(category=="Outside District 7") %>%
      arrange(desc(percent)) %>% 
      mutate(Percent=paste0(round(percent *100,1),"%")) %>%
      select(placenames, Percent), rownames = F, options=list(pageLength = 10, dom = 'tip')
  )
})

output$vis_lbs_tab_top_inside7 <- renderDataTable({
  datatable(
    vis_lbs_home_d7_state_df %>% filter(category=="Inside District 7") %>%
      arrange(desc(percent)) %>% 
      mutate(Percent=paste0(round(percent *100,1),"%")) %>% select(placenames, Percent), rownames = F, options=list(pageLength = 10, dom = 'tip')
  )
})