# TAMPA Mobility Dashboard 
# Developed by Kyeongsu Kim and Reid Haefer at RSG
# Original Framework by Reid, app_original.R, is stored in Archives 
# Begin to develop on 08-01-2023
# latest update: 09-28-2023 11:28 by Kyeongsu Kim; 


source(file.path(getwd(), "data_import.R"))
# library("formattable")

Main_Page = function(){
  tagList(
    dashboardPage(skin="black",
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
                             source(file.path("ui", "ui_1_Overview.R"),  local = TRUE)$value,
                             # source(file.path("ui", "ui_2_Replica_OD.R"),  local = TRUE)$value,
                             source(file.path("ui", "ui_3_rMove_Comp.R"),  local = TRUE)$value,
                             source(file.path("ui", "ui_3_POI_ODs_Flows.R"),  local = TRUE)$value,
                             source(file.path("ui", "ui_4_Trip_Type.R"),  local = TRUE)$value,
                             source(file.path("ui", "ui_5_LU_Service_Population.R"),  local = TRUE)$value,
                             source(file.path("ui", "ui_6_Vis_Emp_Res.R"),  local = TRUE)$value,
                             source(file.path("ui", "ui_7_LBS.R"),  local = TRUE)$value,
                             source(file.path("ui", "ui_8_Covid.R"),  local = TRUE)$value,
                             source(file.path("ui", "ui_9_Commercial_Spending.R"),  local = TRUE)$value,
                             source(file.path("ui", "ui_10_Commercial_Vehicles.R"),  local = TRUE)$value
                             )
                    ), 
                    # footer
                    h5("Copyright | TAMPA MOBILITY STUDY | FDOT DISTRICT 7", style=" color: #585353; font-weight: bold;  text-align: center")
                    
                  )
    )
  )
}


ui <- shinyUI(htmlOutput('Webpage'))


server <- function(input, output, session) {
  
  log_path <- paste("logs/log_", substr(Sys.time(), 1, 10), ".txt", sep = "")
  log_txt = "-------------- Session Start --------------"
  cat(file=log_path, log_txt, "\n", append=TRUE)
  message(log_txt)
  
  output$Webpage <- renderUI({Main_Page()})
  
  source(file.path("server", "server_1_Overview.R"),  local = TRUE)$value
  # source(file.path("server", "server_2_Replica_OD.R"),  local = TRUE)$value
  source(file.path("server", "server_3_POI_ODs_Flows.R"),  local = TRUE)$value
  source(file.path("server", "server_4_Trip_Type.R"),  local = TRUE)$value
  source(file.path("server", "server_5_LU_Service_Population.R"),  local = TRUE)$value
  source(file.path("server", "server_6_Visitor_Employee_and_Resident_Locations.R"),  local = TRUE)$value
  source(file.path("server", "server_7_LBS.R"),  local = TRUE)$value
  source(file.path("server", "server_8_COVID.R"),  local = TRUE)$value
  source(file.path("server", "server_9_Commercial_Spending.R"),  local = TRUE)$value
  source(file.path("server", "server_10_Commercial_Vehicles.R"),  local = TRUE)$value
}


shinyApp(ui = ui, server = server)
