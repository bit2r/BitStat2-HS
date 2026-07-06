library(shiny)

# setwd("C:/code_states/BitStat-HS/02_module")

source("curriculum_module.R", encoding = "UTF-8")

ui <- fluidPage(

  curriculum_UI(id = "curriculum")

)

server <- function(input, output, session) {

  curriculum_server(id = "curriculum")

}

shinyApp(ui = ui, server = server)
