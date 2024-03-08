
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#      CCPhos App Test Terminal
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(CCPhosApp)

TestData_Frankfurt <- readRDS("../dsCCPhos/Development/Data/RealData/CCPRealData_Frankfurt.rds")

StartCCPhosApp(CCPTestData = TestData_Frankfurt)



library(dsCCPhosClient)

TestData <- readRDS("../dsCCPhos/Development/Data/RealData/CCPRealData_Frankfurt.rds")

CCPConnections <- ConnectToVirtualCCP(CCPTestData = TestData,
                                      NumberOfSites = 3,
                                      NumberOfPatientsPerSite = 1000)

Messages_ServerRequirements <- CheckServerRequirements(DataSources = CCPConnections)

LoadRawDataSet(DataSources = CCPConnections)

WorkspaceInfo <- GetServerWorkspaceInfo(DataSources = CCPConnections)






if (interactive()){
  library(shiny)
  library(shiny.semantic)

  ui <- semanticPage(
    tabset(tabs =
             list(
               list(menu = "First Tab", content = "Tab 1"),
               list(menu = "Second Tab", content = "Tab 2", id = "second_tab")
             ),
           active = "second_tab",
           id = "exampletabset"
    ),
    h2("Active Tab:"),
    textOutput("activetab")
  )
  server <- function(input, output) {
      output$activetab <- renderText(input$exampletabset)
  }
  shinyApp(ui, server)
}



