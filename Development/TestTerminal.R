
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





