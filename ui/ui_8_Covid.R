
## * 12. "COVID Changes" ========
shinyjs::useShinyjs()

tabPanel("COVID Changes",
         tabBox(width=12,
             fluidRow(
               box(width=12, title="What are the biggest changes in travel behavior post-COVID?",
                   tags$ul(
                     tags$li("The City of Tampa's population is estimated to have shrunk by roughly 1.4% from 2019 to 2023."), 
                     tags$li("General activity levels in Downtown Tampa during winter are roughly 84% of pre-pandemic levels."), 
                     tags$li("Total visitors to Florida were estimated to be roughly 5% higher in 2022 than in 2019.  However, visitors from Canada and overseas were lower by roughly 36% and 28%, respectively."), 
                     tags$li("Total public transit ridership on the Hillsborough Area Regional Transity Authority system has increased 23% from 2019 to 2023."), 
                     tags$li("The overall work-from-home percentage in District 7 counties increased from 8.6% in 2019 to 21.2% in 2021, resulting in roughly an additional 190,000 work-from-home workers.")
                   )
                   )
             ),
             fluidRow(
               box(width=12, title="How much has the City of Tampa's population changed over the course of the pandemic??",
                   column(width=6,
                          formattableOutput("covid_pop_table") %>% withSpinner()
                          ),
                   column(width=6,
                          box(width=12, title="Tampa Population (2019-2023)",
                          plotlyOutput("covid_pop_plot")
                          )
                   )
               )
             ),
             fluidRow(
               box(width=12, title="How much has general activity levels changed in Downtown Tampa?",
                   img(src='covid_photo.png',  height = 600, width = 800)
               )
             ),
             fluidRow(
               box(width=12, title="How much have tourism levels changed in Florida?",
                   column(width=6,
                          formattableOutput("covid_vis_table") %>% withSpinner()
                   ),
                   column(width=6,
                          box(width=12, title="Florida Statewide Visitation - Visitor Origin",
                          plotlyOutput("covid_vis_plot")
                          )
                   )
               )
             ),
             fluidRow(
               box(width=12, title="How much has transit ridership changed in the Hillsborough area?",
                   column(width=4,
                          formattableOutput("covid_transit_table") %>% withSpinner()
                   ),
                   column(width=4,
                          box(width=12, title="Transit Ridership - 2019 & 2022",
                          plotlyOutput("covid_transit_plot")
                          )
                   )
               )
             ),
             fluidRow(
               box(width=12, title="How much has work-from-home changed in District 7 counties?",
                   column(width=6,
                          formattableOutput("covid_wfh_table") %>% withSpinner()
                   ),
                   column(width=6,
                          box(width=12, title="Change in Working From Home",
                          plotlyOutput("covid_wfh_plot")
                          )
                   )
               )
             )
         ) # tabBox closing
) # tab-panel closing
