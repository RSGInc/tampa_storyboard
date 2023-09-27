
## * 4. "Spending" ========
shinyjs::useShinyjs()


tabPanel("Spending",
         tabBox(width=12,
                # 4.1 Model OD Comparison ---------
                tabPanel("Commercial Spending",
                         tabBox(width=12,
                                # 4.1.1 Household Location ---------
                                tabPanel("Spender Home Location",
                                         fluidRow(
                                           # Per Capita Spends by Week ---------
                                           column(width=8,
                                                  box(width=12, title="Per Capita Spends by Week",
                                                      plotlyOutput("spend_tract_date") %>% withSpinner()
                                                  )
                                           ),
                                           # Spending Types ---------
                                           column(width=4,
                                                  box(width=12, title="Spending Types",
                                                      plotlyOutput("spend_tract_type") 
                                                  )
                                           )
                                         ),
                                         fluidRow(
                                           # Home Location of Spender (County) ---------
                                           column(width=8,
                                                  box(width=12, title="Home Location of Spender (County)",
                                                      leafletOutput( 'map_spend_count')
                                                  )
                                           ),
                                           # Total Spend ---------
                                           column(width=4,
                                                  box(width=12, title="Total Spend",
                                                      valueBoxOutput('total_spend_tract', width=12)
                                                  )
                                           )
                                         )
                                ),
                                
                                # 4.1.2 Mercant Location ---------
                                tabPanel("Merchant Location",
                                         fluidRow(
                                           # Per Capita Spends by Week ---------
                                           column(width=8,
                                                  box(width=12, title="Spend Type at Merchants by Week",
                                                      plotlyOutput("spend_county_date") %>% withSpinner()
                                                  )
                                           ),
                                           # Spending Types ---------
                                           column(width=4,
                                                  box(width=12, title="Spending Types",
                                                      plotlyOutput("spend_county_type") 
                                                  )
                                           )
                                         ),
                                         fluidRow(
                                           # Merchant Location ---------
                                           column(width=8,
                                                  box(width=12, title="Merchant Location",
                                                      leafletOutput( 'map_spend_tract')
                                                  )
                                           ),
                                           # Total Spend ---------
                                           column(width=4,
                                                  box(width=12, title="Total Spend",
                                                      valueBoxOutput('total_spend_county', width=12)
                                                  )
                                           )
                                         )
                                )
                         )
                ) # tab-panel 4.1 Commercial Spending closing
    
         ) # tabBox closing
) # tab-panel 4. Spending closing
