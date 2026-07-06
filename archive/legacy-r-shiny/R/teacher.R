
# 3. 교수용 ----------------------
teacher <- function() {
  page(
    href = "/teacher",
    ## UI -------------------------
    ui <- grid_page(

      theme = bitStat_theme,

      layout = c(
        "header header header",
        "hs_dataset teacher_dataset teacher_details",
        "teacher_statistics teacher_viz_numeric teacher_viz_categorical",
        "footer footer footer"
      ),
      row_sizes = c(
        "90px",
        "1.4fr",
        "1.39fr",
        "0.21fr"
      ),
      col_sizes = c(
        "1fr",
        "1fr",
        "1fr"
      ),
      gap_size = "13px",
      grid_card_text(
        area = "header",
        content = "고교 오픈 통계 - 교육용",
        h_align = "start",
        alignment = "center",
        is_title = TRUE
      ),
      grid_card(
        area = "hs_dataset",
        title = "hsData 데이터셋",
        item_gap = "15px",
        selectInput(
          inputId = "hs_dataset_input",
          label = "hsData 패키지 내장 데이터",
          choices = setNames(
            hsData_df$Item,
            hsData_df$Title
          )
        )
      ),
      grid_card(
        area = "teacher_dataset",
        title = "데이터셋",
        scrollable = TRUE,
        item_gap = "15px",
        gt_output("teacher_gt")
      ),
      grid_card(
        area = "teacher_statistics",
        title = "요약통계량",
        item_gap = "15px",
        verbatimTextOutput(
          outputId = "teacher_summary",
          placeholder = TRUE
        )
      ),
      grid_card(
        area = "teacher_details",
        title = "데이터 상세정보",
        scrollable = TRUE,
        item_gap = "15px",
        uiOutput(outputId = "teacher_dataset_details")
      ),
      grid_card(
        area = "teacher_viz_numeric",
        title = "시각화 (숫자형)",
        item_gap = "15px",
        plotOutput(
          outputId = "num_plot",
          width = "100%",
          height = "400px"
        )
      ),
      grid_card(
        area = "teacher_viz_categorical",
        title = "시각화 (범주형)",
        item_gap = "15px",
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
    ),
    ## server -------------------------
    server <- function(input, output, session) {
      # 1. 데이터 선정 ---------------------------------
      hs_dataset <- reactive(
        get(input$hs_dataset_input, asNamespace('hsData'))
      )

      ## 1.1. 데이터 살펴보기: gt ---------------------------------
      output$teacher_gt <- render_gt({

        hs_dataset() %>%
          gt()
      })

      ## 1.2. 데이터 상세 ---------------------------------
      output$teacher_dataset_details <- renderPrint({

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
      output$teacher_summary <- renderPrint({

        hs_dataset() %>%
          skimr::skim()

      })

      # 3. 시각화 ---------------------------------
      ## 3.1. 숫자형 ------------------------------
      output$num_plot <- renderPlot({


        hs_dataset() %>%
          select_if(is.numeric) %>%
          ggpairs() +
          theme_bw()

      })

      ## 3.2. 범주형 ------------------------------
      output$cat_plot <- renderPlot({

        plot_dataset <- hs_dataset() %>%
          select_if(is.factor)

        if(ncol(plot_dataset) == 0) {
          return(NULL)
        } else {
          plot_dataset %>%
            ggpairs() +
            theme_bw()
        }

      })
    }
  )
}
