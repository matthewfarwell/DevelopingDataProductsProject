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
      )

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