library(gridlayout)
library(shiny)
library(shinyjs)

# Function for module UI
curriculum_UI <- function(id) {

  ns <- NS(id)

  grid_page(
    layout = c(
      "header header header header",
      "middle_school_row ms_first ms_second ms_third",
      "high_school_row hs_first hs_second hs_third",
      ". footer footer footer"
    ),
    row_sizes = c(
      "100px",
      "1.3fr",
      "1.3fr",
      "0.4fr"
    ),
    col_sizes = c(
      "115px",
      "1fr",
      "1fr",
      "1fr"
    ),
    gap_size = "15px",
    grid_card_text(
      area = "header",
      content = "고교 오픈 통계",
      h_align = "start",
      alignment = "center",
      is_title = TRUE
    ),
    grid_card(
      area = "ms_first",
      item_gap = "15px",
      title = "중학교 1학년",
      uiOutput("ms_textbook_01")
    ),
    grid_card(
      area = "ms_second",
      item_gap = "15px",
      title = "중학교 2학년",
      uiOutput(outputId = "ms_textbook_02")
    ),
    grid_card(
      area = "ms_third",
      item_gap = "15px",
      title = "중학교 3학년",
      uiOutput(outputId = "ms_textbook_03")
    ),
    grid_card(
      area = "hs_first",
      item_gap = "15px",
      title = "고등학교 1학년",
      uiOutput(outputId = "hs_textbook_01")
    ),
    grid_card(
      area = "hs_second",
      item_gap = "15px",
      title = "고등학교 2학년",
      uiOutput(outputId = "hs_textbook_02")
    ),
    grid_card(
      area = "hs_third",
      item_gap = "15px",
      title = "고등학교 3학년",
      uiOutput(outputId = "hs_textbook_03")
    ),
    grid_card_text(
      area = "footer",
      content = "제작: 한국 R 사용자회",
      alignment = "center"
    ),
    grid_card_text(
      area = "middle_school_row",
      content = "중등",
      alignment = "center"
    ),
    grid_card_text(
      area = "high_school_row",
      content = "고등",
      alignment = "center"
    )
  )
}

# 모듈 함수
curriculum_server <- function(id) {

  moduleServer(id, function(input, output, session) {
    ## 중학교 교과서 ---------------------------------
    output$ms_textbook_01 <- renderUI({
      tags$img(src = "www/high_school_textbook.png", width="35%")
    })
    output$ms_textbook_02 <- renderUI({
      tags$img(src = "high_school_textbook_01.png", width="35%")
    })
    output$ms_textbook_03 <- renderUI({
      tags$img(src = "./catalog/prob-stat-textbook-01.png", width="40%")
    })

    ## 고등학교 교과서 ---------------------------------
    output$hs_textbook_01 <- renderUI({
      tags$img(src = glue::glue("{here::here()}/prob-stat-textbook-04.png"), width="40%")
    })
    output$hs_textbook_02 <- renderUI({
      tags$img(src = glue::glue("{here::here()}/02_module/prob-stat-textbook-04.png"), width="40%")
    })
    output$hs_textbook_03 <- renderUI({
      tags$img(src = glue::glue("{here::here()}/02_module/www/prob-stat-textbook-04.png"), width="40%")
    })
  })
}
