pal_vis_lbs <- colorNumeric(palette = "viridis", domain = vis_lbs_home_state$count)


map_label <- paste0('<strong>', vis_lbs_home_state$NAME, '</strong>',
       '<br/>', 'Number of Visitors: ', '<strong>', vis_lbs_home_state$count, '</strong>', ' ') %>% 
  lapply(htmltools::HTML)


output$map_vis_lbs <-renderLeaflet({
  leaflet() %>% addTiles() %>% 
    addPolygons(data = vis_lbs_home_state, fillColor = pal_vis_lbs(vis_lbs_home_state$count), color='white',weight=1 ,stroke = T, fillOpacity = 0.8, label= ~map_label) %>% 
    addLegend(data = vis_lbs_home_state, position = "bottomright", pal = pal_vis_lbs, values = ~count,title = "Visitor Home Locations",opacity = 1)
})

output$vis_lbs_tab_sum <- renderPlotly({
  ggplotly(
  vis_lbs_home_d7_state_df %>% group_by(category) %>% summarise(percent=sum(percent)) %>%
    ggplot(aes(category, percent)) + geom_col() + theme_minimal() + coord_flip() + xlab("") + ylab('') + theme(axis.text = element_blank())
  )
  })



