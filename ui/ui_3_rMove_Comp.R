
shinyjs::useShinyjs()

linebreaks <- function(n){HTML(strrep(br(), n))}

tabPanel("rMove Comparison",
         fluidRow(
                  box(width = 9, status = 'primary', solidHeader = TRUE, title = "",
                      tags$iframe(style="height:800px; width:100%", src="rMove comparison FINAL.pdf")
                  )
         )
)