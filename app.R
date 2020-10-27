
library(shiny)
library(ggplot2)
library(knitr)
library(datasets)
require(graphics)
library(dplyr)
library(GGally)


source("ui.R", local=TRUE)
source("server.R", local=TRUE)

sa <- shinyApp(ui = ui, server = server)

sa
