
## * 7. "Pass Through Trips" ========
shinyjs::useShinyjs()

YEAR_NAME = "2022"
QTR_NAME  = "Q4"
YR_QTR_NAME = paste0(YEAR_NAME, " ", QTR_NAME)

title_od_comparison  = paste("How does", YR_QTR_NAME, "mobility data-derived trip patterns compare to the travel model?", sep= " ")
trip_characteristics = "Trip Characteristic Information"
subtitle_trip_generation = "Who generates the trips?"
subtitle_trip_purpose    = "What is the purpose of the trips?"
subtitle_trip_tod        = "What does the departure time profile look like the trips?"
subtitle_trip_length     = "What does the trip length profile look like for the trips?"
subtitle_trip_VMT        = "How much VMT do the vehicle trips generate?"
subtitle_trip_mode       = "What is the mode of travel for the person trips?"

tabPanel("Trip Characteristics ",
         tabBox(width=12,
                # Trip Characteristics ---------
                fluidRow(
                  column(width=4,
                         box(width=12, title= trip_characteristics,
                             radioButtons('trip_year', "Select Year", choices = trip_year_choices, selected = trip_year_choices[1], inline=T),
                             selectInput('trip_zone', "Select Zone (Point) of Interest", choices = trip_zone_choices, selected = trip_zone_choices[1])
                         )
                  ),
                  column(width=8, 
                         box(width = 12, title= "Area Map of Interest ",
                             leafletOutput("map_trip_zone_interest", height = 500) %>% withSpinner()
                         )
                  ),
                ), #fluidRow closing
                
                fluidRow(
                  column(width=6,
                         box(width=12, title= subtitle_trip_generation,
                             plotlyOutput("plot_bar_category_gen"),
                             br(),
                             DT::dataTableOutput("trip_gen_table")
                             # DT::DTOutput("trip_gen_table")
                         )
                  ),
                  column(width=6,
                         box(width = 12, title= subtitle_trip_purpose,
                             plotlyOutput("plot_bar_purpose"),
                             br(),
                             verbatimTextOutput("purpose_txtOutput"),
                         )
                  ),
                ), #fluidRow closing
                
                fluidRow(
                  box(width = 12, 
                      # selectInput('trip_purpose', "Select Trip Purposet", choices = purpose_choices, selected = purpose_choices[1]),
                      radioButtons('trip_purpose', "Select Trip Purpose", choices = trip_purpose_choices, selected = trip_purpose_choices[1], inline=T),
                  ),
                  
                  column(width=6,
                         box(width = 12, title= subtitle_trip_tod,
                             plotlyOutput("plot_time_period"),
                             br(),
                             verbatimTextOutput("TOD_txtOutput")
                         )
                  ),
                  column(width=6,
                         box(width = 12, title= subtitle_trip_length,
                             plotlyOutput("plot_distance"),
                         )
                  ),
                ), #fluidRow closing
                
                fluidRow(
                  column(width=6,
                         box(width = 12, title= subtitle_trip_VMT,
                             verbatimTextOutput("VMT_txtOutput"),
                         )
                  ),
                  # column(width=6,
                  #        box(width = 12, title= subtitle_trip_mode,
                  #            # plotlyOutput("plot_bar_chart_TripGen")
                  #        )
                  # )
                ), #fluidRow closing
                
         ) # tabBox closing
) # tab-panel closing
