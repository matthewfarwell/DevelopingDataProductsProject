
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
