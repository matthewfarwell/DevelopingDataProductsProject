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
  titlePanel("mtcars MPG regression modelling"),
  br(),
  sidebarLayout(
    sidebarPanel(
      h1("Please select the variables"),
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
      p(textOutput("sidebarDescription1")),
      p(textOutput("sidebarDescription2"))

    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plots",
          verticalLayout(
            h2(textOutput("plotsText1")),
            p(textOutput("plotsDescription1")),
            plotOutput("plot"),
            h2(textOutput("plotsText2")),
            p(textOutput("plotsDescription2")),
            tableOutput("correlationsPlot")
          )
        ),

        tabPanel("mpg ~ ind1",
          verticalLayout(
            h3(textOutput("formula1")),
            p(textOutput("comparisonDescription1")),
            plotOutput("comparisonPlot1"),
            p(textOutput("summaryDescription1")),
            verbatimTextOutput("summary1")
          )
        ),

        tabPanel("mpg ~ ind1 + ind2",
          verticalLayout(
            h3(textOutput("formula2")),
            p(textOutput("comparisonDescription2")),
            plotOutput("comparisonPlot2"),
            p(textOutput("summaryDescription2")),
            verbatimTextOutput("summary2")
          )
        ),

        tabPanel("mpg ~ ind1 + ind2 + ind3",
          verticalLayout(
            h3(textOutput("formula3")),
            p(textOutput("comparisonDescription3")),
            plotOutput("comparisonPlot3"),
            p(textOutput("summaryDescription3")),
            verbatimTextOutput("summary3")
          )
        ),

        tabPanel("Anova",
          verticalLayout(
            h3(textOutput("anovaTitle")),
            p("Anova output for the three competing models."),
            verbatimTextOutput("anova")
          )
        )
      )
    )
  )
)
