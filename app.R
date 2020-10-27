
library(shiny)
library(ggplot2)
library(knitr)
library(datasets)
require(graphics)
library(dplyr)
library(GGally)

varToDescription <- list(
  am = "am - Transmission,(0 = automatic, 1 = manual)",
  cyl = "cyl - Number of cylinders",
  disp = "disp - Displacement (cu.in.)",
  hp = "hp - Gross horsepower",
  drat = "drat - Rear axle ratio",
  wt = "wt - Weight (1000 lbs)",
  qsec = "qsec - 1/4 mile time",
  vs = "vs - Engine (0 = V-shaped, 1 = straight)",
  gear = "gear - Number of forward gears",
  carb = "carb - Number of carburetors"
)

descriptionToVar <- list(
   "am - Transmission,(0 = automatic, 1 = manual)" = "am",
   "cyl - Number of cylinders" = "cyl",
   "disp - Displacement (cu.in.)" = "disp",
   "hp - Gross horsepower" = "hp",
   "drat - Rear axle ratio" = "drat",
   "wt - Weight (1000 lbs)" = "wt",
   "qsec - 1/4 mile time" = "qsec",
   "vs - Engine (0 = V-shaped, 1 = straight)" = "vs",
   "gear - Number of forward gears" = "gear",
   "carb - Number of carburetors" = "carb"
)

createFormula <- function(cs, n) {
  cols <- cs[1:n]
  paste("mpg~", paste(cols, collapse="+"), sep="")
}

createModel <- function(formula) {
  lm(as.formula(formula), data=mtcars)
}

comparisonPlot <- function(formula) {
  m <- createModel(formula)
  par(mfrow = c(2, 2))
  plot(m)
}

source("ui.R")
source("server.R")

sa <- shinyApp(ui = ui, server = server)

sa
