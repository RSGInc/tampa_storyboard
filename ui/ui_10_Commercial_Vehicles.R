
## * 14. "Commercial Vehicles" ========
shinyjs::useShinyjs()

tabPanel("Commercial Vehicles",
         tabBox(width=12,
                fluidRow(
                  box(width=12, title="",
                  h4(tags$p("The commercial vehicle information can be found on the", tags$a(href="https://public.tableau.com/app/profile/salah.momtaz/viz/jF9Lp2qR7nW6XzGvYeC5A8uD1T0bHk/CommercialVehicle", "Tableau dashboard")))),
                )
         #        fluidRow(column(width=9,
         #                 column(width=4,
         #                        selectInput('select_zone_comm',"Select (POI)", choices=interest_zone_choices)
         #                 ),
         #                 column(width=4,
         #                        radioButtons('year_comm',"Select Year", choices=c('2019','2022'), inline=T, selected='2019')
         #                 ),
         #                 column(width=4,
         #                        radioButtons('vmt_trips_comm',"Select Metric", choices=c('trips','vmt'), inline=T)
         #                 )
         #                 ),
         #                 column(width=3)
         #        ),fluidRow(
         #          column(width=4,
         #                 box(width=12, title="Location of Commercial Vehicle Trip",
         #                     leafletOutput("map_comm_loc") %>% withSpinner()
         #                 )
         #          ),
         #          column(width=8,
         #            fluidRow(
         #              column(width=6,
         #                     valueBoxOutput('comm_vmt_tot', width=6)
         #                     ),
         #              column(width=6,
         #                     valueBoxOutput('comm_trips_tot', width=6)
         #                     )
         #              ),
         #            fluidRow(
         #                 column(width=3,
         #                        box(width=12, title="Trip Type",
         #                 plotlyOutput('comm_trip_type')
         #                        )
         #                 ),
         #                 column(width=3,
         #                        box(width=12, title="Vehicle Type",
         #                          plotlyOutput('comm_vehicle_type')
         #                        )
         #                          ),
         #                 column(width=6,
         #                        box(width=12, title="Trip Length",
         #                                   plotlyOutput('comm_trip_length')
         #                        )
         #                          )
         #                 )
         #          )
         #                 ), fluidRow(
         #                          box(width=12, title="Trip Time of Day",
         #                          plotlyOutput('comm_tod')
         #                          )
         #                 )
          ) # tabBox closing
) # tab-panel closing