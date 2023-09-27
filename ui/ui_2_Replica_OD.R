source(file.path(getwd(), "config_variables.R"))

## * 3. "Replica Trip OD Table" ========
shinyjs::useShinyjs()


tabPanel("Replica Trip OD",
         tabBox(width=12,
                fluidRow(
                  # Select Other Metrics ---------
                  column(width=4,
                         box(width=12, title="Select Parameters",
                             radioButtons('od_traveler_type', "Select Traveler Type", choices = od_traveler_type_choices, selected = od_traveler_type_choices[1],inline=T),
                             # uiOutput('od_purpose'),
                             # selectInput('od_purpose', "Select Trip Purpose", choices = od_purpose_choices, selected = od_purpose_choices[1]),
                             radioButtons('od_selection', "Select Base Map Type", choices = od_selection_choices, selected = od_selection_choices[1], inline=T)),
                         box(width=12, title="Compare Fall 2022 Replica data to 2019 rMerge data",
                             plotlyOutput("od_chart_comparison", height = 390)
                             ),
                         
                         ),
                  column(8,
                         box(width=12, title = paste0('What do Fall 2022 Replilca trip patterns look like in Travel Model O-D format?'),
                             htmlOutput("od_map_header"),
                             leafletOutput("map_trip_compare_od", height = 600) %>% withSpinner()
                             )
                         )
                )
         ) # tabBox closing
) # tab-panel [Replica Trip OD Table] closing
