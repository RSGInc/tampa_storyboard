output$covid_pop_plot <- renderPlotly({
  ggplotly(
  covid_pop %>% ggplot(aes(Year,`Population Estimate`)) + geom_col() + theme_minimal() + xlab("") + ylab('')
  )
  })

output$covid_pop_table<- renderFormattable({
    formattable(
      covid_pop %>%
        mutate(`Population Estimate`=prettyNum(`Population Estimate`, big.mark = ","),
               `Change from 2019`=percent(`Change from 2019`)),
      list(
      `Change from 2019` = color_tile('#fea18e', '#fafed1')
      )
)
})

output$covid_vis_plot <- renderPlotly({
  ggplotly(
    covid_vis %>% pivot_longer(cols=2:4, names_to="geography", values_to="value") %>%
       ggplot(aes(Year,value, fill=geography)) + geom_col() + theme_minimal() + xlab("") + ylab('') + scale_fill_manual(values=c("#b1b1b1","#ba790a","#04a99b"))
  )
})

output$covid_vis_table<- renderFormattable({
  formattable(
    covid_vis %>%
      mutate(Domestic=prettyNum(Domestic, big.mark = ","),
             Overseas=prettyNum(Overseas, big.mark = ","),
             Canada=prettyNum(Canada, big.mark = ","),
             Total=prettyNum(Total, big.mark = ","),
             `Change from 2019`=percent(`Change from 2019`,2)),
    list(
      `Change from 2019` = color_tile('#fea18e', '#fafed1')
    )
  )
})

output$covid_transit_plot <- renderPlotly({
  ggplotly(
    covid_transit %>%
      ggplot(aes(Month,`Monthly Ridership`,)) + geom_col() + theme_minimal() + xlab("") + ylab('')
  )
})

output$covid_transit_table<- renderFormattable({
  formattable(
    covid_transit %>%
      mutate(`Monthly Ridership`=prettyNum(`Monthly Ridership`, big.mark = ","),
             `Change from 2019`=percent(`Change from 2019`,2)),
    list(
      `Change from 2019` = color_tile('#53b125', '#53b125')
    )
  )
})
output$covid_wfh_plot <- renderPlotly({
  ggplotly(
    covid_wfh2 %>%
      pivot_longer(cols=2:3) %>%
      ggplot(aes(County,value, fill=name)) + geom_col() + theme_minimal() + xlab("") + ylab('') + scale_fill_manual( values=c("#b1b1b1","#ba790a"))
  )
})

output$covid_wfh_table<- renderFormattable({
  formattable(
    covid_wfh %>%
      mutate(`Total Workers`=prettyNum(`Total Workers`, big.mark = ","),
             `WFH Workers`=prettyNum(`WFH Workers`, big.mark = ","),
             `WFH%`=percent(`WFH%`,2)),
    list(
      `WFH%` = color_tile('#a9d294', '#d7fecc')
    )
  )
})
#covid_wfh<-read_excel("data/Tampa_Survey_Report_Storyboard_Mockup_v2.xlsx", sheet="covid_wfh")

