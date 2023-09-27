
## * 5. "Trip Generation" ========
shinyjs::useShinyjs()



    
tabPanel("Visitor, Employee, and Resident Locations ",
         tabBox(width=12,
         tabPanel("Visitor",
         tabBox(width=12,
                fluidRow(
                  column(width=6,
                  column(width=6,
                  selectInput('select_zone_vis',"Select Visitor Location (POI)", choices=unique(gis_POI_D7$POI_Description))
                  ),
                  column(width=6,
                 # radioButtons('trav_type',"Select Traveler Type", choices=traveler_type_choices, inline=T),
                  radioButtons('year_vis',"Select Year", choices=c('2019','2022'), inline=T, selected='2019')
                  ))
                ),
                fluidRow(
                  column(width=4,
                         box(width=12, title="Where do visitors live?",
                             leafletOutput("map_vis_loc") %>% withSpinner()
                             ),
                             box(width=12,title ="What is the purpose of trips made by visitors?",
                             plotlyOutput("vis_purpose"), 
                             valueBoxOutput("work_trips_percent"), 
                             valueBoxOutput("hbo_trips_percent")
                             ),
                         box(width=12, title="Top Visitor Home Locations Inside District 7",
                             dataTableOutput("vis_lbs_tab_top_inside7")
                         )
                         ),
                  column(width=8,
                             fluidRow(
                               box(width=12,title ="What is the household size distribution for visitors?", 
                                   plotlyOutput("vis_size")
                                   )
                               ),
                         fluidRow(
                           column(width=7,
                               box(width=12,title ="What is the household income distribution for Visitors?", 
                               plotlyOutput("vis_income")
                               )),
                               column(width=5,
                                      box(width=12,title ="Visitor Location Summary",
                                          plotlyOutput("vis_loc_cat")
                                      )
                                      )
                               ),
                               fluidRow(
                               box(width=12, title="Top Visitor Home Locations Outside District 7",
                                   dataTableOutput("vis_lbs_tab_top_outside7")
                               )
                             )
                  )
                )
                  )
         ),
         tabPanel("Resident",
                  tabBox(width=12,
                         fluidRow(
                           column(width=6,
                           column(width=6,
                                  selectInput('select_zone_res',"Select Home Location", choices=unique(gis_POI_D7$POI_Description))
                           ),
                           column(width=6,
                                  # radioButtons('trav_type',"Select Traveler Type", choices=traveler_type_choices, inline=T),
                                  radioButtons('year_res',"Select Year", choices=c('2019','2022'), inline=T, selected='2019')
                           )
                           )
                         ),
                         fluidRow(
                           column(width=4,
                                  box(width=12, title="Where do residents who work?",
                                      leafletOutput("map_res_tract") %>% withSpinner(),
                                      box(width=12, title="What is the household size distribution?",
                                      plotlyOutput("res_hh_size")
                                      )
                                  )),
                           column(width=8,
                                      fluidRow(
                                        column(width=6,
                                               box(width=12, title="Do residents work from home?",
                                               plotlyOutput("res_emp")
                                               )
                                               ),
                                        column(width=6,
                                               box(width=12, title="How many autos do residents own?",
                                               plotlyOutput("res_vehicles")
                                               )
                                        )
                                      ),
                                      fluidRow(
                                        box(width=12, title="What is the commute mode for residents who work in person?",
                                        plotlyOutput("res_commute")
                                        )
                                      ),
                                      fluidRow(
                                        box(width=12, title="What is the household income distribution?",
                                        plotlyOutput("res_income")
                                        )
                                      )
                           )
                         ))),
         tabPanel("Worker",
                  tabBox(width=12,
                         fluidRow(
                           column(width=6,
                           column(width=6,
                                  selectInput('select_zone_worker',"Select Work Location", choices=unique(gis_POI_D7$POI_Description))
                           ),
                           column(width=6,
                                  # radioButtons('trav_type',"Select Traveler Type", choices=traveler_type_choices, inline=T),
                                  radioButtons('year_worker',"Select Year", choices=c('2019','2022'), inline=T, selected='2019')
                           )
                           )
                         ),
                         fluidRow(
                           column(width=4,
                                  box(width=12, title="Where do employees who work in person live?",
                                      leafletOutput("map_worker_tract") %>% withSpinner()
                                  )),
                           column(width=8,
                                      fluidRow(
                                        column(width=4,
                                               box(width=12, title="Do workers work from home?",
                                               plotlyOutput("worker_emp")
                                               )
                                               ),
                                        column(width=8,
                                               box(width=12, title="What is the household income distribution?",
                                               plotlyOutput("worker_income")
                                               )
                                        )
                                      ),
                                      fluidRow(
                                        box(width=12, title="What is the commute mode for employees who work in person?",
                                        plotlyOutput("worker_commute")
                                        )
                                      )
                           )
                         )))
)) # tab-panel closing

