
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   - Virtual DataSHIELD infrastructure for testing purposes -
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Install newest base DataSHIELD packages
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# devtools::install_github(repo = "datashield/dsBase")
# devtools::install_github(repo = "datashield/dsBaseClient")

# Install own DataSHIELD packages
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# devtools::install_github(repo = "BastianReiter/dsCCPhos")
# devtools::install_github(repo = "BastianReiter/dsCCPhosClient")
# devtools::install_github(repo = "BastianReiter/CCPhosApp")

# Install additional Datashield-packages
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# install.packages("dsTidyverse")
# install.packages("dsTidyverseClient")
#
# devtools::install_github("tombisho/dsSynthetic", dependencies = TRUE)
# devtools::install_github("tombisho/dsSyntheticClient", dependencies = TRUE)
#
# devtools::install_github("neelsoumya/dsSurvival")
# devtools::install_github("neelsoumya/dsSurvivalClient")



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load required packages
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(dsBaseClient)
library(dsCCPhosClient)
library(dsTidyverseClient)
# library(resourcer)

# Print DataSHIELD errors right away
options(datashield.errors.print = TRUE)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Establish Connections to virtual servers using dsCCPhosClient::ConnectToVirtualCCP()
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#TestData <- readRDS("../dsCCPhos/Development/Data/RealData/CCPRealData_Frankfurt.rds")
TestData <- readRDS("../dsCCPhos/Development/Data/TestData/CCPTestData.rds")


CCPConnections <- ConnectToVirtualCCP(CCPTestData = TestData,
                                      NumberOfServers = 3,
                                      NumberOfPatientsPerServer = 2000,
                                      AddedDsPackages = "dsTidyverse")
                                      #Resources = list(TestResource = TestResource))

# Display app in Viewer pane
# options(shiny.launch.browser = .rs.invokeShinyPaneViewer)

ServerExplorer()

TestProcess <- RunAutonomousApp(ShinyAppInitFunction = StartCCPhosApp,
                                Arguments = list(CCPTestData = TestData))

TestProcess$is_alive()
TestProcess$read_all_error()
TestProcess$kill()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load Raw Data Set (RDS) from Opal data base to R sessions on servers
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Messages <- LoadRawDataSet(ServerSpecifications = NULL)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Check RDS tables for existence and completeness
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

RDSTableCheck <- ds.CheckDataSet(DataSetName = "RawDataSet",
                                 AssumeCCPDataSet = TRUE)

View(RDSTableCheck$TableStatus)

View(RDSTableCheck$TableRowCounts$RDS_Diagnosis)
View(RDSTableCheck$FeatureExistence$RDS_Diagnosis)
View(RDSTableCheck$FeatureTypes$RDS_Diagnosis)
View(RDSTableCheck$NonMissingValueRates$RDS_Diagnosis)

RDSTableCheck$TableStatus


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Optionally: Draw random sample from Raw Data Set on servers
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ds.DrawSample(RawDataSetName = "RawDataSet",
              SampleSize = "1000",
              SampleName = "RDSSample")


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Transform Raw Data Set (RDS) into Curated Data Set (CDS)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Transform Raw Data Set (RDS) into Curated Data Set (CDS) (using default settings)
Curation <- ds.CurateData(RawDataSetName = "RawDataSet",
                          Settings = NULL,
                          OutputName = "CurationOutput")

CDSTableCheck <- ds.CheckDataSet(DataSetName = "CuratedDataSet",
                                 AssumeCCPDataSet = TRUE)

# Make tables from Curated Data Set directly addressable by unpacking them into R server session
Messages <- ds.UnpackCuratedDataSet(CuratedDataSetName = "CuratedDataSet")

# Get curation reports
CurationReport <- ds.GetCurationReport()




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Transform Curated Data Set (CDS) into Augmented Data Set (ADS)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Run ds.AugmentData
Messages <- ds.AugmentData(CuratedDataSetName = "CuratedDataSet",
                           OutputName = "AugmentationOutput")

# Make tables from Augmented Data Set directly addressable by unpacking them into R server session
Messages <- ds.UnpackAugmentedDataSet(AugmentedDataSetName = "AugmentedDataSet")

ADSTableCheck <- ds.CheckDataSet(DataSetName = "AugmentedDataSet")



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Get overview of objects in server workspaces
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - Using dsCCPhosClient::GetServerWorkspaceInfo() and dsCCPhosClient::ds.GetObjectMetaData()
#-------------------------------------------------------------------------------

# Collect comprehensive information about all workspace objects
ServerWorkspaceInfo <- GetServerWorkspaceInfo()



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Process ADS tables
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Data Exploration
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Perform exemplary analyses
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~






#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Log out from all servers
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DSI::datashield.logout(CCPConnections)



