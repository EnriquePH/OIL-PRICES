# OIL PRICES: app Shiny (Rscript app/run.R). Baja la serie diaria del Brent
# de la EIA (R/brent.R), la pasa a medias mensuales y ajusta el mismo modelo
# que Brent.R (auto.arima con logaritmos); muestra la previsión y sus
# intervalos. Puerto 8322 (convención 08-PUERTOS de PROYECTOS), 127.0.0.1.
suppressPackageStartupMessages({
  library(shiny)
  library(forecast)
  library(ggplot2)
})

# runApp("app") trabaja dentro de app/: R/brent.R y data/ están arriba
setwd("..")
brent <- new.env()
sys.source("R/brent.R", envir = brent)

estilo <- paste0(
  "body{font-family:system-ui,sans-serif;max-width:1150px;margin:auto}",
  "h2{margin-top:.6rem}"
)

ui <- fluidPage(
  tags$head(tags$style(estilo)),
  titlePanel("Brent: previsión mensual (EIA, USD/barril)"),
  sidebarLayout(
    sidebarPanel(
      width = 3,
      sliderInput("h", "Meses de previsión", min = 3, max = 36, value = 12),
      sliderInput(
        "anios", "Años de historia en la gráfica",
        min = 2, max = 30, value = 8
      ),
      actionButton(
        "bajar", "Bajar cotizaciones de la EIA",
        class = "btn-primary"
      ),
      tags$p(tags$small(textOutput("origen")))
    ),
    mainPanel(
      width = 9,
      plotOutput("grafica", height = "420px"),
      h4("Previsión (USD/barril)"),
      tableOutput("tabla"),
      tags$p(tags$small(textOutput("modelo")))
    )
  )
)

server <- function(input, output, session) {
  datos <- reactive({
    forzar <- input$bajar > 0
    withProgress(message = "Bajando y preparando la serie…", {
      brent$download_brent(max_age_days = if (forzar) 0 else 7)
      daily <- brent$read_brent()
      list(daily = daily, mensual = brent$monthly_brent(daily))
    })
  })
  ajuste <- reactive({
    withProgress(message = "Ajustando el modelo…", {
      auto.arima(datos()$mensual,
        lambda = 0, biasadj = TRUE,
        stepwise = FALSE, approximation = FALSE
      )
    })
  })
  prevision <- reactive(forecast(ajuste(), h = input$h))
  output$grafica <- renderPlot({
    desde <- tail(time(datos()$mensual), 1) - input$anios
    autoplot(prevision()) +
      coord_cartesian(xlim = c(desde, NA)) +
      labs(
        x = NULL, y = "USD/barril", title = NULL,
        caption = paste(
          "Bandas: intervalos de predicción al 80 % y 95 %.",
          "Fuente: EIA (RBRTE)."
        )
      ) +
      theme_minimal(base_size = 13)
  })
  output$tabla <- renderTable(
    {
      fc <- prevision()
      meses <- format(as.Date(zoo::as.yearmon(time(fc$mean))), "%m/%Y")
      data.frame(
        Mes = meses, as.data.frame(fc),
        check.names = FALSE, row.names = NULL
      )
    },
    digits = 2
  )
  output$origen <- renderText({
    paste0(
      "Último dato diario: ", format(end(datos()$daily), "%d/%m/%Y"),
      " · archivo ",
      format(file.mtime(brent$data_path), "%d/%m/%Y %H:%M")
    )
  })
  output$modelo <- renderText({
    paste("Modelo:", capture.output(print(ajuste()))[2])
  })
}

shinyApp(ui, server)
