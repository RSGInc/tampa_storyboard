
serv_pop_lu$POI[serv_pop_lu$POI == "Tropicana Stadium"] = "Tropicana Field"
lu$POI[lu$POI == "Tropicana Stadium"] = "Tropicana Field"
serv_pop_lu$POI[serv_pop_lu$POI == "Clear Water Beach"] = "Clearwater Beach"
lu$POI[lu$POI == "Clear Water Beach"] = "Clearwater Beach"

gis_POI_react<- reactive({
  gis_POI_D7 %>% filter(POI_Description == input$select_zone11)
  })

output$map_POI <-renderLeaflet({
 leaflet() %>% addProviderTiles(providers$CartoDB.Positron, group ="CartoDB.Positron") %>% 
    addPolygons(data=gis_POI_react(), fillColor = "red", color="red", label= ~gis_POI_react()$POI_Description)
})

output$plot_lu_comm<-renderPlotly({
  ggplotly(
    serv_pop_lu %>% filter(cat2=="commercial_info" & POI==input$select_zone11) %>%
      ggplot(aes(reorder(category, -count), count, text= paste(category,'</br>',
                                                               '</br>KSF: ', count))) + 
      geom_col() + coord_flip() + theme_minimal() + xlab("") +ylab('')+theme(axis.text=element_blank()),
    tooltip=c("text")
  )
})

output$plot_lu_res<-renderPlotly({
  ggplotly(
    serv_pop_lu %>% filter(cat2=="res_info" & POI==input$select_zone11) %>% 
      ggplot(aes(reorder(category, -count), count, text= paste(category,'</br>',
                                                               '</br>Dwelling Units: ', count))) + 
      geom_col() + coord_flip() + theme_minimal() + xlab("") +ylab('') +theme(axis.text=element_blank()),
    tooltip=c("text")
  )
})

output$lu_sum_comm <- renderValueBox({
  valueBox(value= 
             prettyNum(
               round(
             serv_pop_lu %>% filter(POI==input$select_zone11 & category=="Total KSF Non-Residential") %>% pull(count)), big.mark = ","
             ), 
           subtitle="Total Non-Residential Building SQFT", color="olive"
  )
})

tot_du <- reactive({
  lu %>% group_by(residential)%>% filter(residential=="yes" & POI==input$select_zone11) %>% summarise(value=sum(value,na.rm=T)) %>% pull(value)
})

output$lu_sum_res <- renderValueBox({
  valueBox(value= 
             prettyNum(
             serv_pop_lu %>% filter(POI==input$select_zone11 & category=="Total Dwelling Units") %>% pull(count), big.mark = ","
             ), 
           subtitle="Total Dwelling Units", color="olive"
  )
})

output$plot_serv_pop<-renderPlotly({
  ggplotly(
    serv_pop_lu %>% filter(POI==input$select_zone11 & cat2=="service_pop") %>%
      ggplot(aes(reorder(category, -count), count, text= paste(category,'</br>',
                                                               '</br>Population: ', count))) +
      geom_col() + coord_flip() + theme_minimal() + xlab("") +ylab(''),
    tooltip=c("text")
  )
})
output$tot_serv_pop <- renderValueBox({
  valueBox(value= 
             prettyNum(
             serv_pop_lu %>% filter(POI==input$select_zone11 & cat2=="service_pop") %>% summarise(count=sum(count)) %>% pull(count), big.mark = ","
             ), 
           subtitle="Total Service Population", color="navy"
  )
})
serv_pop_sum <- reactive({
  service_pop %>% filter(POI != "D7")  %>% filter(year=='2019'& POI==input$select_zone11)%>% group_by(person_type) %>% summarise(count=sum(count,na.rm=T))
})

jth_react <-reactive({
  round(
    serv_pop_lu %>% filter(category == "Rough Jobs Estimate" & POI==input$select_zone11) %>% pull(count) / 
      serv_pop_lu %>% filter(category == "Total Dwelling Units" & POI==input$select_zone11) %>% pull(count),0
  )
})
output$jobs_to_housing <- renderValueBox({
  valueBox(value=if(is.infinite(jth_react())){
    0} else{
      jth_react()
    },
           subtitle="Jobs to Housing", color="navy"
  )
})
rpdu_react <-reactive({
  round(
    serv_pop_lu %>% filter(category=="Residents"& POI==input$select_zone11) %>% pull(count) / 
      serv_pop_lu %>% filter(category=="Total Dwelling Units"& POI==input$select_zone11) %>% pull(count),2
  )
})
output$res_per_hh<- renderValueBox({
  valueBox(value=if(is.na(rpdu_react())){
    0} else{
      rpdu_react()
    }, 
           subtitle="Residents Per DU", color="navy"
  )
})
output$emp_per_ksf<- renderValueBox({
  valueBox(value=
             round(
             serv_pop_lu %>% filter(category=="Rough Jobs Estimate" & POI==input$select_zone11) %>% pull(count) / 
             serv_pop_lu %>% filter(category=="Total KSF Non-Residential" & POI==input$select_zone11) %>% pull(count),3
             ), 
           subtitle="Employees per KSF of Non-Residential Land Use", color="navy"
  )
})