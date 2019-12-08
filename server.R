# Shiny App code

list.of.packages <- c("shinydashboard", "shiny", "caret", "gbm")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(shiny)
library(shinydashboard)
library(caret)
library(rpivotTable)
library(gbm)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Setwd
  # setwd("C:/Users/itaylor/OneDrive - National Theatre/Enterprises")
  setwd("~/Documents/NT Shiny App")
  
  # Load data
  dashbaordData <- readRDS("entsDashboardData.rds")
  predictionZeros <- readRDS("predictionZeros.rds")
  predictionZeros <- as.data.frame(t(predictionZeros))
  
  # Load model
  conversionModel <- readRDS("entsConversionModel_2.rds")
  
  
  predictionData <- reactive({
    dataVariables <- data.frame(
      "TheatreLyttelton" = ifelse(input$theatre=="Lyttelton", 1, 0),
      "TheatreOlivier" = ifelse(input$theatre=="Olivier", 1, 0),
      "SeasonSpring" = ifelse(input$season=="Spring", 1, 0),
      "SeasonSummer" = ifelse(input$season=="Summer", 1, 0),
      "SeasonWinter" = ifelse(input$season=="Winter", 1, 0),
      "PeriodContemporary" = ifelse(input$period=="Contemporary", 1, 0),
      "PeriodModernClassic" = ifelse(input$period=="Modern Classic", 1, 0),
      "GenreComedy" = ifelse(input$genre=="Comedy", 1, 0),
      "GenreDrama" = ifelse(input$genre=="Drama", 1, 0),
      "GenreFamily" = ifelse(input$genre=="Family", 1, 0),
      "GenreMusical" = ifelse(input$genre=="Musical", 1, 0),
      "Intervals1" = ifelse(input$intervals=="1", 1, 0),
      "Intervals2" = ifelse(input$intervals=="2", 1, 0),
      "NewWritingY" = ifelse(input$New_Writing==TRUE, 1, 0),
      "IntellectualY" = ifelse(input$Intellectual==TRUE, 1, 0),
      "EdgyY" = ifelse(input$Edgy==TRUE, 1, 0),
      "RarelyPerformedY" = ifelse(input$Rarely_Performed==TRUE, 1, 0),
      "EntertainmentY" = ifelse(input$Entertainment==TRUE, 1, 0),
      "IssueDrivenY" = ifelse(input$Issue_Driven==TRUE, 1, 0),
      "TopicalY" = ifelse(input$Topical==TRUE, 1, 0),
      "ticketCapacity" = input$ticketCapacity,
      "grossPotential" = input$grossPotential,
      "Rain" = input$Rain,
      "Temperature" = input$Temperature,
      "PlayRating2" = ifelse(input$PlayRating=="2", 1, 0),
      "PlayRating3" = ifelse(input$PlayRating=="3", 1, 0),
      "PlayRating4" = ifelse(input$PlayRating=="4", 1, 0),
      "PlayRating5" = ifelse(input$PlayRating=="5", 1, 0),
      "DirectorRating2" = ifelse(input$DirectorRating=="2", 1, 0),
      "DirectorRating3" = ifelse(input$DirectorRating=="3", 1, 0),
      "PlaywrightRating2" = ifelse(input$PlaywrightRating=="Lyttelton", 2, 0),
      "PlaywrightRating3" = ifelse(input$PlaywrightRating=="Lyttelton", 3, 0),
      "PlaywrightRating4" = ifelse(input$PlaywrightRating=="Lyttelton", 4, 0),
      "PlaywrightRating5" = ifelse(input$PlaywrightRating=="Lyttelton", 5, 0),
      "CastRating2" = ifelse(input$CastRating=="2", 1, 0),
      "CastRating3" = ifelse(input$CastRating=="3", 1, 0),
      "CastRating4" = ifelse(input$CastRating=="4", 1, 0),
      "CastRating5" = ifelse(input$CastRating=="5", 1, 0),
      "Reviews3" = ifelse(input$Reviews=="3", 1, 0),
      "Reviews4" = ifelse(input$Reviews=="4", 1, 0),
      "Reviews5" = ifelse(input$Reviews=="5", 1, 0),
      "TravelexYNY" = ifelse(input$Travelex_YN==TRUE, 1, 0),
      "PreviewsPC" = input$previews/input$performances,
      "PressPC" = input$press/input$performances,
      "CaptionedPC" = input$captioned/input$performances,
      "LastPC" = ifelse(input$last==TRUE, 1, 0)/input$performances,
      "CompsPC" = input$CompsPC,
      "wdMatPC" = input$wdMat/input$performances,
      "wdEvePC" = input$wdEve/input$performances,
      "weMatPC" = input$weMat/input$performances,
      "weEvePC" = input$weEve/input$performances
    )
    
    # dataVariables <- droplevels(dataVariables)
    # 
    # dmy <- dummyVars(" ~ .",
    #                  data = dataVariables,
    #                  fullRank = T)
    # dataVariables.dummies <- data.frame(predict(dmy,
    #                                         newdata = dataVariables))
    # names(dataVariables.dummies) <- gsub("[[:punct:]]", "",  names(dataVariables.dummies))
    # 
    # predictionData_all <- cbind(dataVariables.dummies[1, ],
    #                             predictionZeros[, !names(predictionZeros) %in% names(dataVariables.dummies)])
  })
  
  # output$OverallPivot <- renderTable({
  #     predictionData()
  # })
  
  output$conversionBox <- renderValueBox({
    valueBox(
      round(predict(conversionModel, predictionData()), 2),
      "Estimated conversion rate",
      icon = icon("credit-card"),
      color = "yellow"
    )
  })
  
  # output$sphBox <- renderValueBox({
  #     valueBox(
  #         "3.50",
  #         "Estimated spend per head",
  #         icon = icon("credit-card"),
  #         color = "blue"
  #     )
  # })
}