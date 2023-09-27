library(shiny)
library(shinydashboard)
library(leaflet)
library(plotly)
library(tidyverse)
library(readr)
library(data.table)
library(shinycssloaders)
library(scales)
library(sf)

linebreaks <- function(n){HTML(strrep(br(), n))}

# spending data
source(file.path("config.R"))

# spend_county<-fread("data/2022 Q4/spend_by_merchant_county_fullweek.csv") %>%
#   mutate(date=mdy(week_starting))
# 
# spend_tract<-fread("data/2022 Q4/spend_by_merchant_tract_fullweek.csv") %>%
#   mutate(date=mdy(week_starting))  %>%
#   st_as_sf(crs=4326, coords=c('latitude','longitude'))

dbHeader <- dashboardHeader()
dbHeader$children[[2]]$children <-  tags$a(href='http://mycompanyishere.com',
                                           tags$img(src='logo.png',height='60',width='200'))

ui <- dashboardPage(skin="black",
                    ## dashboardHeader -------------
                    dashboardHeader(title="Tampa Travel Analysis",titleWidth = 450,
                                    tags$li(class = "dropdown",
                                            tags$a(href="https://rsginc.com/", target="_blank", 
                                                   tags$img(height = "19px", alt="RSG Logo", src="RSG Logo.jpg")))
                    ),
                    
                    ## dashboardSidebar -------------
                    dashboardSidebar(disable=T),
                    
                    
                    ## dashboardBody -------------
                    dashboardBody(
                      fluidRow(
                        tabBox(width=12,
                             # Tab 1: Introduction -------------
                             tabPanel("Introduction",
                                      fluidRow(
                                        column(width=6,
                                               box(width=12,
                                                   h2(tags$b("Purpose")),
                                                    h4(Text_Intro_Purpose1),
                                                    h4(Text_Intro_Purpose2),
                                                    h4(Text_Intro_Purpose3),
                                                   h2(tags$b("User Instructions")),
                                                    h4(Text_Intro_User_Instructions),
                                                   h3(tags$b("Analysis Content #1")),
                                                    h4(Text_Intro_Analysis_Content1),
                                                   h3(tags$b("Analysis Content #2")),
                                                    h4(Text_Intro_Analysis_Content2),
                                                   h3(tags$b("Documentation")),
                                                    h4(Text_Intro_Documentation),
                                                   linebreaks(2),
                                                   img(src='RSG Logo.jpg',  height = 80, width = 250),
                                                   linebreaks(2),
                                                    h4(tags$p(Text_Intro_bottom, tags$a(href="https://github.com/RSGInc/tampa_mobility/tree/main/dashboard", "Github")))
                                                  )
                                              ), 
                                        column(width=6,
                                               img(src='Example_Cover_Photo.jpg',  height = 600, width = 500) # include page main photograph
                                              )
                                      )
                                    ),
                             
                             # Tab 2: User's Manuel -------------
                             tabPanel("User's Manuel"),
                             
                             # Tab 3: Model OD Comparison -------------
                             tabPanel("Model OD Comparison",
                                      # tabBox(width=12,
                                             fluidRow(
                                               column(width=4,
                                                      box(width=12, title="Select Zones",
                                                          column(width=6,
                                                                 selectInput('interest_zone',"Select Zone of Interest", choices = c("Downtown Tampa","Downtown St. Petersburg","zone 3"))),
                                                          column(width=6,
                                                                 selectInput('comp_zone',"Select Zone to Compare", choices = c("zone 1","zone 2","zone 3"))),
                                                          # fluidRow(
                                                          radioButtons("zone_display","Choose Zone Display Info", choices=c("Zone Comparison","Zone of Interest Data Only"), inline=T)
                                                      )
                                               ),
                                               column(width=8,
                                                      fluidRow(
                                                        box(width=12, title="Select Types of Metrics",
                                                            column(width=3,
                                                                   selectInput('time_period',"Select Time Period", choices = c("AM","PM"), width='200px'),
                                                                   selectInput('day',"Select Day of Week", choices = c("Monday","Tuesday","Wednesday"), width='200px')
                                                            ),
                                                            column(width=3,
                                                                   selectInput('traveler_type',"Select Traveler Type", choices = c("Resident","Visitor","Employee"), width='200px'),
                                                                   selectInput('mode',"Select Mode", choices = c("Auto","Walk","Transit"), width='200px'),
                                                                   selectInput('purpose',"Select Trip Purpose", choices = c("Home-Based Work","Work-Based Other","Other-Based Other"),width='200px')
                                                            ),
                                                            column(width=3,
                                                                   sliderInput('party_size',"Select Travel Party Size", min=1, max=10, value=c(1,10), width='200px'),
                                                                   sliderInput('trip',"Select Trip Distance", min=1, max=100, value=c(1,100), width='200px'))
                                                        )
                                                      )
                                               )
                                             ),
                                             fluidRow(
                                               box(width = 12, title= "Results",
                                                   fluidRow(
                                                     column(width=6,
                                                            column(width=6,
                                                                   box(width=12, title="Zone of Interest",
                                                                       leafletOutput("map1") %>% withSpinner()
                                                                   )
                                                            ), column(width=6,
                                                                      box(width=12, title="Comparison Zone",
                                                                          leafletOutput("map2")
                                                                      )
                                                            )
                                                     ),
                                                     column(width=6,
                                                            box(width=12, title="Trips by Purpose",
                                                                plotlyOutput('plot1')
                                                            )
                                                     )
                                                   ),
                                                   fluidRow(
                                                     column(width=6,
                                                            box(width=12, title="Trips by Mode",
                                                                plotlyOutput("plot2") 
                                                            )
                                                     ),
                                                     column(width=6,
                                                            box(width=12, title="Trips by Destination",
                                                                plotlyOutput('plot3') 
                                                            )
                                                     )
                                                   ),
                                                   fluidRow(
                                                     column(width=6,
                                                            box(width=12, title="Mode Share",
                                                                plotlyOutput("plot4")
                                                            )
                                                     ),
                                                     column(width=6,
                                                            box(width=12, title="Household Income",
                                                                plotlyOutput('plot5') 
                                                            )
                                                     )
                                                   )
                                               )
                                             )
                                      # )
                             ),
                             # Tab 4: LU Service Population -------------
                             tabPanel("LU Service Population"),
                             # Tab 5: Trip Generation -------------
                             tabPanel("Trip Generation"),
                             # Tab 6: Trip Characteristics -------------
                             tabPanel("Trip Characteristics"),
                             # Tab 7: Pass Through Trips -------------
                             tabPanel("Pass Through Trips"),
                             # Tab 8: Visitor Trips -------------
                             tabPanel("Visitor Trips"),
                             # Tab 9: Employee Tripa -------------
                             tabPanel("Employee Trips"),
                             # Tab 10: Resident Trips -------------
                             tabPanel("Resident Trips"),
                             # Tab 11: LBS Visitor Home Locations -------------
                             tabPanel("LBS Visitor Home Locations"),
                             # Tab 12: COVID Changes -------------
                             tabPanel("COVID Changes"),
                             # Tab 13: Commercial Spending -------------
                             tabPanel("Commercial Spending",
                                      # tabBox(width=12,
                                             tabPanel("Home Location",
                                                      fluidRow(
                                                        box(width=12, "",
                                                            column(width=2,
                                                                   selectInput('traveler_type1',"Select Traveler Type", choices = c("Resident","Visitor","Employee"), width='200px')
                                                            ),
                                                            column(width=2,
                                                                   selectInput('mode1',"Select Mode", choices = c("Auto","Walk","Transit"), width='200px')
                                                            ),
                                                            column(width=2,
                                                                   selectInput('purpose1',"Select Trip Purpose", choices = c("Home-Based Work","Work-Based Other","Other-Based Other"),width='200px'))
                                                        )
                                                      ),
                                                      fluidRow(
                                                        column(width=8,
                                                               box(width=12, title="Per Capita Spends by Week",
                                                                   plotlyOutput("spend_tract_date") %>% withSpinner()
                                                               )
                                                        ),
                                                        column(width=4,
                                                               box(width=12, title="Spending Types",
                                                                   plotlyOutput("spend_tract_type") 
                                                               )
                                                        )
                                                      ),fluidRow(
                                                        column(width=8,
                                                               box(width=12, title="Home Location of Spender (County)",
                                                                   leafletOutput( 'map_spend_tract')
                                                               )
                                                        ),
                                                        column(width=4,
                                                               box(width=12, title="Total Spend",
                                                                   valueBoxOutput('total_spend_tract', width=12)
                                                               )
                                                        )
                                                      )
                                             ),
                                             tabPanel("Mercant Location",
                                                      fluidRow(
                                                        box(width=12, "",
                                                            column(width=2,
                                                                   selectInput('traveler_type2',"Select Traveler Type", choices = c("Resident","Visitor","Employee"), width='200px')
                                                            ),
                                                            column(width=2,
                                                                   selectInput('mode2',"Select Mode", choices = c("Auto","Walk","Transit"), width='200px')
                                                            ),
                                                            column(width=2,
                                                                   selectInput('purpose2',"Select Trip Purpose", choices = c("Home-Based Work","Work-Based Other","Other-Based Other"),width='200px'))
                                                        )
                                                      ),
                                                      fluidRow(
                                                        column(width=8,
                                                               box(width=12, title="Spend Type at Merchants by Week",
                                                                   plotlyOutput("spend_county_date") %>% withSpinner()
                                                               )
                                                        ),
                                                        column(width=4,
                                                               box(width=12, title="Spending Types",
                                                                   plotlyOutput("spend_county_type") 
                                                               )
                                                        )
                                                      ),fluidRow(
                                                        column(width=8,
                                                               box(width=12, title="Merchant Location",
                                                                   leafletOutput( 'map_spend_count')
                                                               )
                                                        ),
                                                        column(width=4,
                                                               box(width=12, title="Total Spend",
                                                                   valueBoxOutput('total_spend_county', width=12)
                                                               )
                                                        )
                                                      )
                                             )
                                      # )
                             ),
                             # Tab 14: Commercial Vehicles -------------
                             tabPanel("Commercial Vehicles"),
                             # Tab 15: Documentation -------------
                             tabPanel("Documentation",
                                      tabBox(width=12,
                                             tabPanel("Written Documentation"),
                                             tabPanel("Additional Documentation #1"),
                                             tabPanel("Additional Documentation #2"),
                                             tabPanel("Additional Documentation #3")
                                      ))
                             # Tab End -------------
                      )
                    )
                )
)


server <- function(input, output, session){
  output$total_spend_tract  <-renderValueBox({
    valueBox(dollar_format()(sum(spend_tract$spend)), "Total Spending", width=12)
  })
  output$map_spend_tract <-renderLeaflet({
    leaflet() %>% addTiles() %>% setView(lng = -82.457176, lat = 27.950575, zoom = 12)
  })
  output$spend_tract_type  <- renderPlotly({
    ggplotly(
      spend_tract %>% data.frame() %>% group_by(Type) %>% summarise(spend=sum(spend,na.rm=T)) %>% ggplot(aes(Type, spend)) + geom_col() + coord_flip() +theme_minimal()
    )
  })
  output$spend_tract_date  <- renderPlotly({
    ggplotly(
      spend_tract%>% data.frame() %>% group_by(Type, date) %>% summarise(spend=sum(spend,na.rm=T)) %>% 
        ggplot(aes(date, spend, group=Type, color=Type)) + geom_line() +theme_minimal()
    )
  })
  output$total_spend_county  <-renderValueBox({
    valueBox(dollar_format()(sum(spend_county$spend)), "Total Spending", width=12)
  })
  output$map_spend_count <-renderLeaflet({
    leaflet() %>% addTiles() %>% setView(lng = -82.457176, lat = 27.950575, zoom = 12)
  })
  output$spend_county_type  <- renderPlotly({
    ggplotly(
      spend_county %>% group_by(Type) %>% summarise(spend=sum(spend,na.rm=T)) %>% ggplot(aes(Type, spend)) + geom_col() + coord_flip() +theme_minimal()
    )
  })
  output$spend_county_date  <- renderPlotly({
    ggplotly(
      spend_county %>% group_by(Type, date) %>% summarise(spend=sum(spend,na.rm=T)) %>% 
        ggplot(aes(date, spend, group=Type, color=Type)) + geom_line() +theme_minimal()
    )
  })
  output$map1  <-renderLeaflet({
    leaflet() %>% addTiles() %>% setView(lng = -82.457176, lat = 27.950575, zoom = 12)
  })
  output$map2  <-renderLeaflet({
    leaflet() %>% addTiles() %>% setView(lng = -82.457176, lat = 27.950575, zoom = 12)
  })
  output$plot1<-renderPlotly({
    ggplotly(
      mtcars %>% ggplot(aes(mpg, gear)) + geom_col() +theme_minimal()
    )
  })
  output$plot2<-renderPlotly({
    ggplotly(
      mtcars %>% ggplot(aes(mpg, gear)) + geom_line() +theme_minimal()
    )
  })
  output$plot3<-renderPlotly({
    ggplotly(
      mtcars %>% ggplot(aes(mpg, gear)) + geom_point() +theme_minimal()
    )
  })
  output$plot4<-renderPlotly({
    ggplotly(
      mtcars %>% ggplot(aes(qsec, carb)) + geom_point() +theme_minimal()
    )
  })
  output$plot5<-renderPlotly({
    ggplotly(
      mtcars %>% ggplot(aes(disp, cyl)) + geom_area() +theme_minimal()
    )
  })
}


shinyApp(ui, server)
