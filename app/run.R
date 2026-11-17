# Arranca la app: Rscript app/run.R → http://127.0.0.1:8322
# (convención 08-PUERTOS de PROYECTOS; SHINY_PORT para otro puerto).
shiny::runApp("app",
  host = Sys.getenv("SHINY_HOST", "127.0.0.1"),
  port = as.integer(Sys.getenv("SHINY_PORT", "8322")),
  launch.browser = FALSE
)
