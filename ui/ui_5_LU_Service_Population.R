
## * 4. "LU Service Population" ========
shinyjs::useShinyjs()

tabPanel("LU & Service Population",
         tabBox(width=12,
                fluidRow(
                  column(width=3,
                  selectInput('select_zone11',"Select Zone", choices=unique(gis_POI_D7$POI_Description))
                )
                ),
                fluidRow(
                  column(width=4,
                         box(width=12, title="Zone",
                             leafletOutput("map_POI") %>% withSpinner()
                         )),
                  column(width=8,
                         box(width=12, title="Land Use Profile",
                             fluidRow(valueBoxOutput("lu_sum_comm"),
                                      valueBoxOutput("lu_sum_res")
                             ),
                             fluidRow(
                               column(width=6,
                                      box(width=12, title="Commercial Land Uses",
                               plotlyOutput('plot_lu_comm')
                                      )
                               ),
                               column(width=6,
                                      box(width=12, title="Residential Land Uses",
                               plotlyOutput('plot_lu_res')
                                      )
                               )
                             )
                         )
                  )
                ),
                fluidRow(
                  box(width=12, "Service Population Profile",
                      fluidRow(
                      column(width=6,
                             valueBoxOutput('tot_serv_pop'),
                             valueBoxOutput('jobs_to_housing'),
                             valueBoxOutput('res_per_hh'),
                             valueBoxOutput('emp_per_ksf')),
                      column(width=6,
                             box(width=12, title="Total Service Population",
                    plotlyOutput('plot_serv_pop')
                             )
                    ))
                      )
                )
         ) # tabBox closing
) # tab-panel closing
