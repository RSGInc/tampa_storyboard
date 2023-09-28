
## * 1. "Introduction" ========

# Text_Intro_Purpose1 = "- Focus on visitors, then workers, then residents"
# Text_Intro_Purpose2 = "- Supplementing rMove visitor and worker studies conducted pre-COVID"
# Text_Intro_Purpose3 = "- Want an updated understanding of travel (and how things have changed) since that work/COVID "
# Text_Intro_User_Instructions = "The Tampa Bay Region Visitor Survey Augment seeks to utilize new mobility data analytics in combination with previous survey work conducted in the region in order to perform comparisons of travel patterns and habits as we presumably settle into new post-Covid conditions with a focus on understanding the changes in visitor and worker travel patterns before and after COVID-19. In part, this work will seek to define what questions these data can and cannot answer. Our proposed analysis will aim to document the changes that have occurred and inform future data collection needs, while perhaps helping to refine policy focus. Some questions that might be answered by this analysis include: What new challenges have arisen as a result of COVID-19? What previous challenges may be less pressing today? How have trends tracked for years before COVID-19 been impacted? Are they accelerated, dampened, or reversed? During the course of this work, RSG will coordinate with FDOT staff to identify and develop additional questions of interest.The analysis will produce origin-destination trip tables for trips to/from the Tampa Bay Region as a whole, as well as for specific geographic subarea locations such as Busch Gardens and Downtown Tampa.  Trip tables will be produced for Fall 2019 and Fall 2022 conditions, and will be segmented by day of week, time of day, general trip purpose categories, and trip maker classification (residents, workers who live outside the region/geographic subarea, and non-work-related visitors including tourists). RSG follows the latest developments in the mobility data analytics space and has evaluated multiple potential data products for this study to determine their strengths, limitations, and whether they could reliably answer FDOT’s questions around visitor and worker travel patterns and demographics. RSG determined that a combination of data products was optimal, to leverage the benefits and fill in the gaps of the individual sources.RSG recommends the combination of Replica simulated travel pattern data with new mobility analytics data from location-based services (LBS) data sources. The Replica data source will provide RSG with detailed travel behavior and demographic data for trip making within the Florida, Georgia, and South Carolina megaregion, while the LBS data source will provide the home location and destination of visitors from locations within the United States. The two data sources will be combined to provide an updated look at not only visitor and worker travel, but all travel within, to, from, and through the Tampa Bay Region."
# Text_Intro_Analysis_Content1 = "Text to explain what is in the Analysis Content #1 tab  - TextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextText"
# Text_Intro_Analysis_Content2 = "Text to explain what is in the Analysis Content #2 tab  - TextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextText"
# Text_Intro_Documentation     = "Text to explain what is in the documentation tab  - TextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextText"
 Text_Intro_bottom            = "This tool was created in Shiny and the full tool code can be found on"
 Text_Intro_app_version       = paste0("Dashboard Version: ", app_version)

shinyjs::useShinyjs()

linebreaks <- function(n){HTML(strrep(br(), n))}

tabPanel("Overview",
         tabBox(width=12,
                tabPanel("Introduction",
         fluidRow(
           column(width=6,
                  box(width=12,
                      h2("Introduction/Study Purpose"),
                      h4("FDOT D7 previously engaged RSG to design a comprehensive, 5-year, regional survey program collectively called the Tampa Bay Regional Travel Surveys. This survey program was designed to support the update to the Tampa Bay Regional Planning Model (TBRPM), the Tampa Bay Activity-Based Model (TBABM), the regional Long-Range Transportation Plans (LRTPs), and other regional planning efforts.  This survey studied household demographics, daily travel activities, and typical travel patterns throughout the five-county Tampa Bay region of Citrus, Hernando, Hillsborough, Pasco, and Pinellas counties.  Data was collected between October 2018 and April 2019, with over 4,500 households and 9,000 people participating. "),
                         linebreaks(1),
                         h4("The Tampa Bay Regional Travel Survey Augment seeks to utilize new mobility data analytics in combination with previous travel survey work to identify and perform comparisons of travel patterns and habits as we presumably settle into new post-Covid conditions.  The study was designed to characterize visitor, worker, and resident travel behavior for a more recent Fall 2022 baseline condition, as understanding the travel behavior of households in the travel region helps agencies prioritize transportation improvements to fit the region's needs.  A focus of the study was on capturing and providing supplemental data for visitors given the region's high volumes of seasonal residents, tourists, and special generator attractions like beaches and theme parks that render residential address-driven travel surveys alone insufficient for a complete understanding of travel behavior."),
                      linebreaks(1),
                      h4("RSG follows the latest developments in the mobility data analytics space and evaluated multiple potential data products for the study to determine their strengths, limitations, and whether they could reliably answer FDOT's questions around visitor, as well as resident and worker, travel patterns and demographics. RSG determined that a combination of data products was optimal, to leverage the benefits and fill in the gaps of the individual sources."),
                      linebreaks(1),
                      h4("RSG utilized a combination of Replica simulated travel pattern data with mobility data from location-based services (LBS) sources. The Replica data source provided detailed travel behavior and demographic data for trip making within the Florida, Georgia, and South Carolina megaregion, while the LBS data source provided the home location of visitors to D7 from locations within the United States. Data from the two mobility data sources were analyzed, presented, and compared alongside rMove travel survey data collected during the Tampa Bay Regional Travel Surveys.  The data presented offers multiple data points from multiple sources, each with their own unique set of strengths and limitations, to help provide FDOT D7 with an updated look at not only visitor and worker travel, but all travel within, to, from, and through the Tampa Bay Region for Fall 2022 conditions."),
                      linebreaks(1),
                      h4("The Replica data analysis produced Fall 2022 average weekday origin-destination trip tables consistent with the TBRPM traffic analysis zone (TAZ) system.  The study also identified how many trips on an average weekday are associated with visitors, residents and employees, where those trips start and end, where the trip makers live and work, the predominant modes, times of travel, lengths of trips and other characteristics for the Tampa Bay region as a whole, as well as for ten specific points of interest (POIs) with high visitation levels including Busch Gardens, Clearwater Beach, and the Port Tampa Bay Cruise Terminals & Florida Aquarium. "),
                      linebreaks(2),
                      img(src='RSG Logo.jpg',  height = 80, width = 250),
                      linebreaks(2),
                      h4(tags$p(Text_Intro_bottom, tags$a(href="https://github.com/RSGInc/tampa_storyboard", "Github"))),
                      linebreaks(2),
                      h4(Text_Intro_app_version, style="font-weight: bold")
                  )
           ), 
           column(width=6,
                  img(src='map.png',  height = 600, width = 500) # include page main photograph
           )
         )
), tabPanel("Additional Documentation",
            fluidRow(
              column(width=6,
                     box(width=12,
                         h2("Information on Github Repository"),
                         h4(tags$p('This project involved the development of analytical programming code for a variety of tasks. The full code can be found within a repository on ',
                         tags$a(href="https://github.com/RSGInc/tampa_storyboard", "Github."),"This respository contains all of the code related to the Shiny
                                                             dashboard. The repository contains the following sections.")),
                         linebreaks(1),
                         h3("Github Url"),
                         linebreaks(1),
                         h4("https://github.com/RSGInc/tampa_storyboard"),
                         linebreaks(1),
                         h3("data"),
                         h4("All of the data that is used within the dashboard. These summarized datasets are the result of significant processing of raw data by RSG."),
                         linebreaks(1),
                         h3("server"),
                         h4("This folder contains the 'server' side files of the dashboard, which contains all of the reactive dashboard logic. Each server file is associated with a ui file in the UI folder."),
                         linebreaks(1),
                         h3("ui"),
                         h4("This folder contains the 'ui' files of the dashboard, which contains all of code related to the user interface. Each ui file is associated with a server file in the UI folder."),
                         linebreaks(1),
                         h3("www"),
                         h4("Static files"),
                         linebreaks(1),
                         h3("app.R"),
                         h4("This file is used to organize all pieces of the dashboard. Run this file in rstudio to launch the dashboard on a local computer."),
                         linebreaks(1),
                         h3("data_import.R"),
                         h4("This is ran in the background to load all of the necessary data.")
                     )
              ), 
              column(width=6,
                     img(src='github.png',  height = 600, width = 680) # include page main photograph
              )
            )
)
)
)