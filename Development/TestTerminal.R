
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#      CCPhos App Test Terminal
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(CCPhosApp)


TestData <- readRDS("../dsCCPhos/Development/Data/TestData/CCPTestData.rds")

#RDSTableCheck <- readRDS(file = "C:/Users/Basti/Desktop/RDSTableCheck.RDS")

#CurationReport <- readRDS(file = "C:/Users/Basti/Desktop/CurationReport_10000.RDS")

StartCCPhosApp(CCPTestData = TestData,
               RDSTableCheckData = RDSTableCheck,
               CurationReportData = CurationReport)







#TestData_Frankfurt <- readRDS("../dsCCPhos/Development/Data/RealData/CCPRealData_Frankfurt.rds")
#TestData_WithEmptyTables <- readRDS("../dsCCPhos/Development/Data/TestData/CCPTestData_WithEmptyTables.rds")

#SiteSpecifications <- dsCCPhosClient::CCPSiteSpecifications




library(dsCCPhosClient)

TestData <- readRDS("../dsCCPhos/Development/Data/RealData/CCPRealData_Frankfurt.rds")

CCPConnections <- ConnectToVirtualCCP(CCPTestData = TestData,
                                      NumberOfSites = 3,
                                      NumberOfPatientsPerSite = 1000)

Messages_ServerRequirements <- CheckServerRequirements(DataSources = CCPConnections)

LoadRawDataSet(DataSources = CCPConnections)

WorkspaceInfo <- GetServerWorkspaceInfo(DataSources = CCPConnections)



