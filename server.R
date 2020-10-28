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
  factors <- eventReactive(c(input$variable1, input$variable2, input$variable3), {
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
  
  output$sidebarDescription1 <- renderText({ factors(); "Please select the independent variables for the linear regression with MPG as the dependent variable." })
  output$sidebarDescription2 <- renderText({ factors(); "This app will perform a linear regression using the independent variables selected. It will model mpg vs variable 1, then mpg vs variable 1 and 2, then mpg vs variable 1, 2 and 3." })
  output$sidebarDescription3 <- renderText({ factors(); "Select the tabs to look at the relevant plots" })

  output$plotsText1 <- renderText({ factors(); "Independent variables vs MPG" })
  output$plotsDescription1 <- renderText({ factors(); "This shows the plots of the independent variables against MPG" })
  output$plotsText2 <- renderText({ factors(); "Correlations between variables and MPG" })
  output$plotsDescription2 <- renderText({ factors(); "These are correlations between the independent variables and MPG" })

  formula1 <- reactive({ createFormula(factors(), 1) })
  model1 <- reactive({ createModel(formula1()) })
  output$comparisonPlot1 <- renderPlot({ comparisonPlot(model1()) })
  output$formula1 <- renderText({ formula1() })
  output$comparisonDescription1 <- renderText({ formula1(); "These are the comparison plots to allow you to assess the fit of the model for MPG vs first independent variable" })
  output$summary1 <- renderPrint({ summary(model1()) })
  output$summaryDescription1 <- renderText({ formula1(); "The output of the summary() function in R for this model" })

  formula2 <- reactive({ createFormula(factors(), 2) })
  model2 <- reactive({ createModel(formula2()) })
  output$comparisonPlot2 <- renderPlot({ comparisonPlot(model2()) })
  output$comparisonDescription2 <- renderText({ formula1(); "These are the comparison plots to allow you to assess the fit of the model for MPG vs first and second independent variables" })
  output$formula2 <- renderText({ formula2() })
  output$summary2 <- renderPrint({ summary(model2()) })
  output$summaryDescription2 <- renderText({ formula1(); "The output of the summary() function in R for this model" })

  formula3 <- reactive({ createFormula(factors(), 3) })
  model3 <- reactive({ createModel(formula3()) })
  output$comparisonPlot3 <- renderPlot({ comparisonPlot(model3()) })
  output$comparisonDescription3 <- renderText({ formula1(); "These are the comparison plots to allow you to assess the fit of the model for MPG vs first, second and third independent variables" })
  output$formula3 <- renderText({ formula3() })
  output$summary3 <- renderPrint({ summary(model3()) })
  output$summaryDescription3 <- renderText({ formula1(); "The output of the summary() function in R for this model" })

  output$anova <- renderPrint({ anova(model1(), model2(), model3()) })
  output$anovaTitle <- renderText({ paste(formula1(), "VS", formula2(), "VS", formula3()) })
}
