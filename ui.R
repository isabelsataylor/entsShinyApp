# Shiny App code

list.of.packages <- c("shinydashboard", "shiny", "caret", "gbm")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(shiny)
library(shinydashboard)
library(caret)
library(rpivotTable)
library(gbm)

# Define UI for application that draws a histogram
ui <- dashboardPage(
  
  dashboardHeader(
    title = "Enterprises prediction tool",
    titleWidth = 300),
  
  dashboardSidebar(
    collapsed = TRUE,
    sidebarMenu()
  ),
  
  dashboardBody(
    
    fluidRow(
      
      valueBoxOutput("conversionBox") #,
      
      # valueBoxOutput("sphBox")
      
      # tableOutput('OverallPivot'#, width = "100%", height = "500px")
      
    ),
    
    fluidRow(
      
      column(width = 3,
             
             box(title = "Context",
                 width = NULL, solidHeader = TRUE, status = "primary",
                 selectInput("season",
                             "Season:",
                             unique(dashbaordData$Season),
                             selected =  unique(dashbaordData$Season)[1]),
                 sliderInput("Temperature",
                             "Temperature:",
                             value = mean(dashbaordData$Temperature),
                             min = 0, max = 40),
                 sliderInput("Rain",
                             "Rainfall:",
                             value = mean(dashbaordData$Rain),
                             min = 0, max = 20)),
             
             box(title = "Ticket makeup",
                 width = NULL, solidHeader = TRUE, status = "primary",
                 sliderInput("ticketCapacity",
                             "Ticket capacity (%)",
                             value = 70,
                             min = 0, max = 100),
                 sliderInput("CompsPC",
                             "Comps (%)",
                             value = 20,
                             min = 0, max = 100),
                 sliderInput("grossPotential",
                             "Gross potential (%)",
                             value = 70,
                             min = 0, max = 100)
             )
      ),
      
      column(width = 3,
             
             box(title = "Scheduling",
                 width = NULL, solidHeader = TRUE, status = "primary",
                 numericInput("performances",
                              "Total number of performances:",
                              value = 20,
                              min = 0, max = 300),
                 checkboxInput("last",
                               "Includes last performance?",
                               FALSE),
                 checkboxInput("Travelex_YN",
                               "Travelex performance?",
                               FALSE),
                 
                 "Breakdown of performances",
                 numericInput("previews",
                              "Number of preview performances:",
                              value = 0,
                              min = 0, max = 300),
                 numericInput("press",
                              "Number of press performances:",
                              value = 0,
                              min = 0, max = 1),
                 numericInput("captioned",
                              "Number of captioned performances:",
                              value = 0,
                              min = 0, max = 300),
                 numericInput("wdMat",
                              "Number of weekday matinees:",
                              value = 2,
                              min = 0, max = 7),
                 numericInput("wdEve",
                              "Number of weekday evenings:",
                              value = 5,
                              min = 0, max = 7),
                 numericInput("weMat",
                              "Number of weekend matinees:",
                              value = 2,
                              min = 0, max = 7),
                 numericInput("weEve",
                              "Number of weekend evenings:",
                              value = 5,
                              min = 0, max = 7))
      ),
      
      
      column(width = 3,
             
             box(title = "Logistics",
                 width = NULL, solidHeader = TRUE, status = "primary",
                 selectInput("theatre",
                             "Theatre:",
                             c("Dorfman", "Lyttelton", "Olivier"),
                             selected = "Olivier"),
                 selectInput("intervals",
                             "Intervals:",
                             unique(dashbaordData$Intervals),
                             selected =  unique(dashbaordData$Intervals)[1])
             ),
             
             box(title = "Performance characteristics",
                 width = NULL, solidHeader = TRUE, status = "primary",
                 selectInput("period",
                             "Period:",
                             unique(dashbaordData$Period),
                             selected =  unique(dashbaordData$Period)[1]),
                 selectInput("genre",
                             "Genre:",
                             unique(dashbaordData$Genre),
                             selected =  unique(dashbaordData$Genre)[1]),
                 
                 checkboxInput("New_Writing", "New writing?", FALSE),
                 checkboxInput("Intellectual", "Intellectual?", FALSE),
                 checkboxInput("Edgy", "Edgy?", FALSE),
                 checkboxInput("Rarely_Performed", "Rarely performed?", FALSE),
                 checkboxInput("Entertainment", "Entertainment?", FALSE),
                 checkboxInput("Issue_Driven", "Issue driven?", FALSE),
                 checkboxInput("Topical", "Topical?", FALSE))
      ),
      
      column(width = 3,
             
             box(title = "Performance ratings",
                 width = NULL, solidHeader = TRUE, status = "primary",
                 selectInput("PlayRating",
                             "Play rating:",
                             c(0, 1, 2, 3, 4, 5),
                             selected =  3),
                 selectInput("DirectorRating",
                             "Director rating:",
                             c(0, 1, 2, 3, 4, 5),
                             selected =  3),
                 selectInput("PlaywrightRating",
                             "Playwrighting rating:",
                             c(0, 1, 2, 3, 4, 5),
                             selected =  3),
                 selectInput("CastRating",
                             "Cast rating:",
                             c(0, 1, 2, 3, 4, 5),
                             selected =  3),
                 selectInput("Popularity",
                             "Popularity:",
                             c(0, 1, 2, 3, 4, 5),
                             selected =  3),
                 selectInput("Reviews",
                             "Reviews:",
                             c(0, 1, 2, 3, 4, 5),
                             selected =  3)
             )
      )
    )
  )
)