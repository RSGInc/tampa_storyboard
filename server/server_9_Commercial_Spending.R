output$total_spend_tract  <-renderValueBox({
  valueBox(dollar_format()(sum(spend_tract$spend)), "Total Spending", width=12, color="navy")
})

tract_spend_data<-reactive({
  tract_spend_point %>%
  left_join(
    spend_tract %>%
      group_by(geoid) %>%
      mutate(geoid=as.character(geoid)) %>%
      summarise(spend=sum(spend)), by=c("GEOID"="geoid")
  )
})
tract_spend_map_label <- reactive({
  paste0('Census Tract: ', '<strong>',tract_spend_data()$GEOID, '</strong>',
         '<br/>', 'Spending: ', '<strong>',dollar(tract_spend_data()$spend), '</strong>', ' ') %>% 
    lapply(htmltools::HTML)
})
output$map_spend_tract <-renderLeaflet({
leaflet() %>% addTiles() %>% 
    addCircles(data=  tract_spend_data(),radius = ~sqrt(spend)/10, color="red", weight = 0, fillOpacity = .4,label=tract_spend_map_label(),
                                                                 highlightOptions = highlightOptions(
                                                                   color = "black",
                                                                   weight=1,
                                                                   fillOpacity = 0
                                                                 )) %>% 
    addProviderTiles(providers$CartoDB.Positron, group ="CartoDB.Positron")
})


output$spend_tract_type  <- renderPlotly({
  ggplotly(
    spend_tract %>% data.frame() %>% group_by(Type) %>% summarise(spend=sum(spend,na.rm=T)) %>% 
      ggplot(aes(reorder(Type, -spend), spend, text= paste(Type,'</br>',
                                                           '</br>Amount: ', spend))) + 
      geom_col() + coord_flip() +theme_minimal() + xlab("") + ylab(""),
    tooltip="text"
  )
})

output$spend_tract_date  <- renderPlotly({
  ggplotly(
    spend_tract%>% data.frame() %>% group_by(Type, date) %>% summarise(spend=sum(spend,na.rm=T)) %>% 
      ggplot(aes(date, spend, group=Type, color=Type)) + geom_line() +theme_minimal() + xlab("") + ylab("") +
      scale_color_manual(values=c("#b1b1b1","#ba790a","#04a99b","#050505","#045690","#d0ca02")) +
      theme(axis.text.y=element_blank())
  )
})

output$total_spend_county  <-renderValueBox({
  valueBox(dollar_format()(sum(spend_county$spend)), "Total Spending", width=12, color="navy")
})

national_county_spend<-reactive({
  county_point %>%
    left_join(
      spend_county %>% data.frame() %>% group_by(home_geo_id) %>%
        summarise(spend=sum(spend,na.rm=T)) %>%
        mutate(home_geo_id=as.character(home_geo_id)), by=c("GEOID"="home_geo_id")
    ) %>% filter(!is.na(spend))
})
map_spend_count_label <- reactive({
  paste0('Census Tract: ', '<strong>',national_county_spend()$GEOID, '</strong>',
         '<br/>', 'Spending: ', '<strong>',dollar(national_county_spend()$spend), '</strong>', ' ') %>% 
    lapply(htmltools::HTML)
})
output$map_spend_count <-renderLeaflet({
  national_county_spend() %>% leaflet() %>% addTiles() %>% 
    addCircles(data=  national_county_spend(),radius = ~sqrt(spend), color="red", weight = 0, fillOpacity = .4,label=map_spend_count_label(),
               highlightOptions = highlightOptions(
                 color = "black",
                 weight=1,
                 fillOpacity = 0
               )) %>% 
    addProviderTiles(providers$CartoDB.Positron, group ="CartoDB.Positron")
})
output$spend_county_type  <- renderPlotly({
  ggplotly(
    spend_county %>% group_by(Type) %>% summarise(spend=sum(spend,na.rm=T)) %>% 
      ggplot(aes(reorder(Type,-spend), spend, text= paste(Type,'</br>',
                                                          '</br>Amount: ', spend))) + 
      geom_col() + coord_flip() +theme_minimal() + xlab("") + ylab(""),
    tooltip="text"
  )
})

output$spend_county_date  <- renderPlotly({
  ggplotly(
    spend_county %>% group_by(Type, date) %>% summarise(spend=sum(spend,na.rm=T)) %>% 
      ggplot(aes(date, spend, group=Type, color=Type)) + geom_line() +theme_minimal() + xlab("") + ylab("")  +
      scale_color_manual(values=c("#b1b1b1","#ba790a","#04a99b","#050505","#045690","#d0ca02")) +
      theme(axis.text.y=element_blank())
  )
})