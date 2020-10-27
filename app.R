
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

ui <- fluidPage(
  titlePanel("mtcars regression modelling"),
  
  sidebarLayout(
    sidebarPanel(
      h1("Please select independent variables"),
      selectInput(
        "variable1",
        "First",
        choices = descriptionToVar,
        selected = 'am',
        multiple = FALSE,
        selectize = TRUE,
        width = NULL,
        size = NULL
      ),
      selectInput(
        "variable2",
        "Second",
        choices = descriptionToVar,
        selected = 'disp',
        multiple = FALSE,
        selectize = TRUE,
        width = NULL,
        size = NULL
      ),
      selectInput(
        "variable3",
        "Third",
        choices = descriptionToVar,
        selected = 'carb',
        multiple = FALSE,
        selectize = TRUE,
        width = NULL,
        size = NULL
      ),
      actionButton("analyse", "Analyse")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plots",
          verticalLayout(
            h2(textOutput("plotsText1")),
            plotOutput("plot"),
            h2(textOutput("plotsText2")),
            tableOutput("correlationsPlot")
          )
        ),

        tabPanel("mpg ~ am + ind1",
          verticalLayout(
            h3(textOutput("formula1")),
            plotOutput("comparisonPlot1"),
            verbatimTextOutput("summary1")
          )
        ),

        tabPanel("mpg ~ am + ind1 + ind2",
          verticalLayout(
            h3(textOutput("formula2")),
            plotOutput("comparisonPlot2"),
            verbatimTextOutput("summary2")
          )
        ),

        tabPanel("mpg ~ am + ind1 + ind2 + ind3",
          verticalLayout(
            h3(textOutput("formula3")),
            plotOutput("comparisonPlot3"),
            verbatimTextOutput("summary3")
          )
        ),

        tabPanel("Anova",
          verticalLayout(
            h3(textOutput("anovaTitle")),
            p("Anova output for the three competing models"),
            verbatimTextOutput("anova")
          )
        )
      )
    )
  )
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

server <- function(input, output, session) {
  factors <- eventReactive(input$analyse, {
    c(input$variable1, input$variable2, input$variable3)
  })

  output$plot <- renderPlot({
    par(mfrow = c(1, length(factors())))
    
    sapply(factors(), function(v) {
      plot(mtcars[[v]], mtcars$mpg, ylab="MPG", xlab=varToDescription[[v]])
    })
  })

  output$correlationsPlot <- renderTable({
    round(cor(subset(mtcars, select=c('mpg', factors()))), 2)
  })

  output$plotsText1 <- renderText({ factors(); "Independent variables vs MPG" })
  output$plotsText2 <- renderText({ factors(); "Correlations between variables and MPG" })

  formula1 <- reactive({ createFormula(factors(), 1) })
  model1 <- reactive({ createModel(formula1()) })
  output$comparisonPlot1 <- renderPlot({ comparisonPlot(model1()) })
  output$formula1 <- renderText({ formula1() })
  output$summary1 <- renderPrint({ summary(model1()) })

  formula2 <- reactive({ createFormula(factors(), 2) })
  model2 <- reactive({ createModel(formula2()) })
  output$comparisonPlot2 <- renderPlot({ comparisonPlot(model2()) })
  output$formula2 <- renderText({ formula2() })
  output$summary2 <- renderPrint({ summary(model2()) })

  formula3 <- reactive({ createFormula(factors(), 3) })
  model3 <- reactive({ createModel(formula3()) })
  output$comparisonPlot3 <- renderPlot({ comparisonPlot(model3()) })
  output$formula3 <- renderText({ formula3() })
  output$summary3 <- renderPrint({ summary(model3()) })

  output$anova <- renderPrint({ summary(anova(model1(), model2(), model3())) })
  output$anovaTitle <- renderText({ paste(formula1(), "VS", formula2(), "VS", formula3()) })
}

sa <- shinyApp(ui = ui, server = server)

sa
