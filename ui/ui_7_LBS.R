
## * 11. "LBS Visitor Home Locations" ========
shinyjs::useShinyjs()

tabPanel("Visitor Home Locations",
         tabBox(width=12,
                fluidRow(
                  column(width=6,
                         box(width=12, title="All Visitor Home Locations (% of total)", #height='300px',
                             plotlyOutput("vis_lbs_tab_sum", height="250px")
                         )
                         ),
                  column(width=6,
                         box(width=12, "Non-Florida Visitor Home States",
                             leafletOutput("map_vis_lbs", height=550) %>% withSpinner())
                             )
                ),
                fluidRow(
                  box(width = 9, title = "",
                      tags$iframe(style="height:800px; width:100%", src="Tampa_LBS_Visitor_Home_Locations.pdf")
                  )
                )
         ) # tabBox closing
) # tab-panel closing
