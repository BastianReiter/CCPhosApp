
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#      CCPhos App Test Terminal
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(CCPhosApp)



CurationReport <- readRDS(file = "./Development/Data/CurationReport.rds")

StartCCPhosApp(CCPhosData = CurationReport)
