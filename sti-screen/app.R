
#
# Shiny app for Bacterial STI Screening Rates by Symptomatic Status among
#               Men Who Have Sex with Men in the United States: A Hierarchical
#               Bayesian Analysis. Sexually Transmitted Diseases.
# Authors: Jenness SM, Weiss KM, Prasad P, Zlotorzynska M, Sanchez T
# Date: July 5, 2018
#

library(shiny)
library(shinythemes)
suppressPackageStartupMessages(library(rstan))
library(markdown)
library(ggplot2)


# Categories --------------------------------------------------------------

geos <- c("Atlanta", "Boston", "Chicago", "Dallas", "Denver", "Detroit",
          "Houston", "Los Angeles", "Miami", "New York City", "Philadelphia",
          "San Diego", "San Francisco", "Seattle", "Washington", "Census Div 1",
          "Census Div 2", "Census Div 3", "Cenvus Div 4", "Census Div 5",
          "Census Div 6", "Census Div 7", "Census Div 8", "Census Div 9", "Average Geography")
races <- c("Black/AA", "Hispanic", "Other", "White")
hiv <- c("Infected", "Uninfected")



# Fx ----------------------------------------------------------------------

qn <- function(x, lq = 0.025, hq = 0.975, d = 3) {
  round(quantile(x, c(0.5, lq, hq)), d)
}


# UI ----------------------------------------------------------------------

ui <- navbarPage("MSM STI Screening",
                 theme = shinytheme("flatly"),
                 tabPanel("About",
                          column(1),
                          column(8,
                                 includeMarkdown("intro.md")
                          )
                 ),
                 tabPanel("Screening Rates (TS2)",
                          sidebarLayout(
                              sidebarPanel(
                                  h4("Model Inputs"),
                                  selectInput("t2Out", "Outcome",
                                              c("All Testing/Screening" = "c1",
                                                "Symptomatic Testing" = "c2",
                                                "Asymptomatic Screening" = "c3")),
                                  selectInput("t2Geo", "Geographic Unit", geos),
                                  selectInput("t2Race", "Race/Ethnicity", races),
                                  numericInput("t2Age", "Age", min = 15, max = 65, value = 35),
                                  selectInput("t2HIV", "HIV Status",
                                              c("HIV Infected" = "HIVp",
                                                "HIV Uninfected" = "HIVn")),
                                  numericInput("t2Pnum", "Partner Number", min = 0, max = 200,
                                               value = 2),
                                  br(),
                                  h4("Output Options"),
                                  sliderInput("t2CrI", "Credible Intervals",
                                              min = 0, max = 1, step = 0.001,
                                              value = c(0.025, 0.975)),
                                  numericInput("t2SigDig", "Significant Digits",
                                               min = 0, max = 5, value = 2)

                              ),
                              mainPanel(
                                  h4("Estimated Rate"),
                                  verbatimTextOutput("dataOutT2"),
                                  br(),
                                  h4("Density Plot"),
                                  plotOutput("plotOutT2")
                              )
                          )
                 ),
                 tabPanel("Never Screening (TS4)",
                          sidebarLayout(
                            sidebarPanel(
                              h4("Model Inputs"),
                              selectInput("t3Out", "Outcome",
                                          c("All Testing/Screening" = "c1",
                                            "Symptomatic Testing" = "c2",
                                            "Asymptomatic Screening" = "c3")),
                              selectInput("t3Geo", "Geographic Unit", geos),
                              selectInput("t3Race", "Race/Ethnicity", races),
                              numericInput("t3Age", "Age", min = 15, max = 65, value = 35),
                              selectInput("t3HIV", "HIV Status",
                                          c("HIV Infected" = "HIVp",
                                            "HIV Uninfected" = "HIVn")),
                              numericInput("t3Pnum", "Partner Number", min = 0, max = 200,
                                           value = 2),
                              br(),
                              h4("Output Options"),
                              sliderInput("t3CrI", "Credible Intervals",
                                          min = 0, max = 1, step = 0.001,
                                          value = c(0.025, 0.975)),
                              numericInput("t3SigDig", "Significant Digits",
                                           min = 0, max = 5, value = 3)

                            ),
                            mainPanel(
                              h4("Estimated Probability"),
                              verbatimTextOutput("dataOutT3"),
                              br(),
                              h4("Density Plot"),
                              plotOutput("plotOutT3")
                            )
                          )
                 )
)


# Server ------------------------------------------------------------------

server <- function(input, output, session) {


  ### Testing Rates Tab ###

  d_t2 <- reactive({
      if (input$t2Out == "c1") {
          readRDS("data/t2.fit1.rda")
      } else if (input$t2Out == "c2") {
          readRDS("data/t2.fit2.rda")
      } else if (input$t2Out == "c3") {
          readRDS("data/t2.fit3.rda")
      }
  })

  pred_exp <- reactive({
    df <- as.data.frame(d_t2())
    names(df)[1:25] <- geos
    names(df)[26:32] <- c("Black/AA", "Hispanic", "Other", "Age", "agesq", "HIV", "Pnum")
    # head(df)

    geo <- input$t2Geo
    race <- input$t2Race
    age <- input$t2Age
    hiv <- input$t2HIV
    pnum <- input$t2Pnum

    geo.vec <- df[, geo]
    if (race == "White") {
      race.vec <- rep(0, nrow(df))
    } else {
      race.vec <- df[, race]
    }
    age.vec <- df[, "Age"]
    agesq.vec <- df[, "agesq"]
    if (hiv == "HIVn") {
      hiv.vec <- rep(0, nrow(df))
    } else {
      hiv.vec <- df[, "HIV"]
    }
    pnum.vec <- df[, "Pnum"]

    pred.raw <- geo.vec + race.vec + age.vec*age + agesq.vec*(age^2) + hiv.vec + pnum.vec*pnum
    pred.exp <- exp(pred.raw - log(2))
    pred.exp
  })

  output$dataOutT2  <- renderPrint({
    pred.qn <- qn(pred_exp(), lq = input$t2CrI[1], hq = input$t2CrI[2], d = input$t2SigDig)
    names(pred.qn) <- c("Estimate", "95% CrI", "")
    print(pred.qn)
  })

  output$plotOutT2 <- renderPlot({
    pdf <- as.data.frame(pred_exp())
    names(pdf) <- "preds"
    ggplot(pdf, aes(x = preds)) + geom_density(fill = "#3B9AB2", alpha = 0.8) +
      xlim(0, max(4, max(pdf$preds))) + xlab("Estimated Rate") + theme_minimal()
  })


  ### Never Testing Tab ###

  d_t3 <- reactive({
    if (input$t3Out == "c1") {
      readRDS("data/t3.fit1.rda")
    } else if (input$t3Out == "c2") {
      readRDS("data/t3.fit2.rda")
    } else if (input$t3Out == "c3") {
      readRDS("data/t3.fit3.rda")
    }
  })

  pred_expit <- reactive({
    df <- as.data.frame(d_t3())
    names(df)[1:25] <- geos
    names(df)[26:32] <- c("Black/AA", "Hispanic", "Other", "Age", "agesq", "HIV", "Pnum")

    geo <- input$t3Geo
    race <- input$t3Race
    age <- input$t3Age
    hiv <- input$t3HIV
    pnum <- input$t3Pnum

    geo.vec <- df[, geo]
    if (race == "White") {
      race.vec <- rep(0, nrow(df))
    } else {
      race.vec <- df[, race]
    }
    age.vec <- df[, "Age"]
    agesq.vec <- df[, "agesq"]
    if (hiv == "HIVn") {
      hiv.vec <- rep(0, nrow(df))
    } else {
      hiv.vec <- df[, "HIV"]
    }
    pnum.vec <- df[, "Pnum"]

    pred.raw <- geo.vec + race.vec + age.vec*age + agesq.vec*(age^2) + hiv.vec + pnum.vec*pnum
    pred.expit <- exp(pred.raw)/(1 + exp(pred.raw))
    pred.expit
  })

  output$dataOutT3  <- renderPrint({
    pred.qn <- qn(pred_expit(), lq = input$t3CrI[1], hq = input$t3CrI[2], d = input$t3SigDig)
    names(pred.qn) <- c("Estimate", "95% CrI", "")
    print(pred.qn)
  })

  output$plotOutT3 <- renderPlot({
    pdf <- as.data.frame(pred_expit())
    names(pdf) <- "preds"
    ggplot(pdf, aes(x = preds)) + geom_density(fill = "#F21A00", alpha = 0.8) +
      xlim(0, 1) + xlab("Estimated Probability") + theme_minimal()
  })

}


# Run App -----------------------------------------------------------------

shinyApp(ui = ui, server = server)
