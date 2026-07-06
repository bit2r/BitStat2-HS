library(gridlayout)
library(shiny)
library(tidyverse)
library(gt)
library(skimr)
library(GGally)
library(sortable)
library(bslib)
library(thematic)
library(devtools)

# GitHub 개발버전
# devtools::install_github("bit2r/hsData")

library(hsData)

# 외양 --------------------------

bitStat_theme = bs_theme(
  bootswatch = "cosmo",
  version = 5,
  # 한글 글꼴
  heading_font = font_google("Gowun Dodum"),
  base_font    = font_google("Nanum Myeongjo"),
  code_font    = font_google("Nanum Gothic Coding"),
  # heading_font = font_collection(font_google("Gowun Dodum"), font_google("Nanum Gothic"), "sans-serif"),
  # base_font    = font_collection(font_google("Nanum Myeongjo"), font_google("Noto Serif Korean"), "serif"),
  # code_font    = font_collection(font_google("Nanum Gothic Coding"), "monospace"),
  # Controls the default grayscale palette
  # bg = "#202123", fg = "#B8BCC2",
  # Controls the accent (e.g., hyperlink, button, etc) colors
  primary = "#EA80FC", secondary = "#48DAC6",
  # 입력 상자 테두리 색상
  "input-border-color" = "#202123",
  "input-focus-border-color" = "#202123"
)


# 데이터 ----------------------
hsData_list <- data(package = "hsData")

hsData_df <- hsData_list$results %>%
  as_tibble() %>%
  select(Item, Title)

# 학생용 ----------------------

## 1. UI -------------------------
ui <- grid_page(

  theme = bitStat_theme,

  layout = c(
    "student_title student_title student_title student_title",
    "student_select student_dataset student_info student_variable",
    "student_statistics student_statistics student_num_viz student_cat_viz",
    "footer footer footer footer"
  ),
  row_sizes = c(
    "90px",
    "1.4fr",
    "1.4fr",
    "0.20fr"
  ),
  col_sizes = c(
    "0.5fr",
    "0.5fr",
    "1fr",
    "1fr"
  ),
  gap_size = "1rem",
  grid_card_text(
    area = "student_title",
    content = "고교 통계 - 학생",
    alignment = "center",
    is_title = TRUE
  ),
  grid_card(
    area = "student_select",
    title = "데이터셋",
    item_gap = "12px",
    selectInput(
      inputId = "hs_dataset_input",
      label = "hsData 패키지 내장 데이터",
      choices = setNames(
        hsData_df$Item,
        hsData_df$Title
      )
    ),
    scrollable = TRUE
  ),
  grid_card(
    area = "student_dataset",
    title = "데이터셋",
    item_gap = "12px",
    scrollable = TRUE,
    gt_output("student_gt")
  ),
  grid_card(
    area = "student_info",
    title = "상세정보",
    item_gap = "12px",
    scrollable = TRUE,
    uiOutput(outputId = "student_dataset_details")
  ),
  grid_card(
    area = "student_variable",
    title = "변수 선택",
    item_gap = "12px",
    scrollable = TRUE,
    htmlOutput("bucketlist")
  ),
  grid_card(
    area = "student_statistics",
    title = "요약 통계량",
    item_gap = "12px",
    verbatimTextOutput(
      outputId = "student_descriptive",
      placeholder = TRUE
    )
  ),
  grid_card(
    area = "student_num_viz",
    title = "시각화 (숫자형)",
    item_gap = "12px",
    plotOutput(
      outputId = "num_plot",
      width = "100%",
      height = "400px"
    )
  ),
  grid_card(
    area = "student_cat_viz",
    title = "시각화 (범주형)",
    item_gap = "12px",
    plotOutput(
      outputId = "cat_plot",
      width = "100%",
      height = "400px"
    )
  ),
  grid_card_text(
    area = "footer",
    content = "제작: 한국 R 사용자회",
    alignment = "center"
  )
)

## 2. server -------------------------
server <- function(input, output, session) {
  # 0. 변수명 선택 UI -------------------
  output$bucketlist <- renderUI({
    bucket_list(
      header = "변수를 한개 선택해서 옮기세요",
      group_name = "bucket_list_group",
      orientation = "horizontal",
      add_rank_list(
        text = "데이터셋 변수들",
        labels = names(hs_dataset()),
        input_id = "all_variables"
      ),
      add_rank_list(
        text = "분석 변수",
        labels = NULL,
        input_id = "target_variable"
      )
    )
  })

  # 1. 데이터 선정 ---------------------------------
  hs_dataset <- reactive(
    get(input$hs_dataset_input, asNamespace('hsData'))
  )

  ## 1.1. 데이터 살펴보기: gt ---------------------------------
  output$student_gt <- render_gt({

    hs_dataset() %>%
      gt()
  })

  ## 1.2. 데이터 상세 ---------------------------------
  output$student_dataset_details <- renderPrint({

    static_help <- function(pkg, topic, out, links = tools::findHTMLlinks()) {
      pkgRdDB = tools:::fetchRdDB(file.path(find.package(pkg), 'help', pkg))
      force(links)
      tools::Rd2HTML(pkgRdDB[[topic]], out, package = pkg,
                     Links = links, no_links = is.null(links))
    }

    tmp <- tempfile()
    static_help("hsData", input$hs_dataset_input, tmp)
    out <- readLines(tmp)
    headfoot <- grep("body", out)
    cat(out[(headfoot[1] + 1):(headfoot[2] - 1)], sep = "\n")
  })

  # 2. 요약 통계량: skimr ---------------------------------
  output$student_descriptive <- renderPrint({

    hs_dataset() %>%
      select(input$target_variable) %>%
      summary()
  })

  # 3. 시각화 ---------------------------------
  ## 3.1. 숫자형 ------------------------------
  output$num_plot <- renderPlot({

    req(input$target_variable)

    plot_dataset <- hs_dataset() %>%
      select(input$target_variable)

    if(length(which(sapply(plot_dataset, is.numeric))) == 0) {
      return(NULL)
    } else {
      plot_dataset %>%
        select_if(is.numeric) %>%
        ggpairs() +
        theme_bw()
    }

  })

  ## 3.2. 범주형 ------------------------------
  output$cat_plot <- renderPlot({

    req(input$target_variable)

    plot_dataset <- hs_dataset() %>%
      select(input$target_variable)

    if(length(which(sapply(plot_dataset, is.factor))) == 0) {
      return(NULL)
    } else {
      plot_dataset %>%
        select_if(is.factor) %>%
        ggpairs() +
        theme_bw()
    }

  })
}

shiny::shinyApp(ui, server)

