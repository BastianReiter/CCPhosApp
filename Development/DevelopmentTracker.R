

#===============================================================================
#
# CCPhosApp DEVELOPMENT TRACKER
#
#===============================================================================


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Packages used for development
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(devtools)
#library(shiny.info)
library(sass)


# Compiling of .css-file from SASS-file using package 'sass'
sass(input = sass_file("./Development/CCPhosStyle.scss"),
     options = sass_options(output_style = "compressed"),      # Outputs the .css-file in compressed form
     output = "./inst/app/www/styles/CCPhosStyle.min.css")



# Set preferred license in description
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# use_ccby_license()


# Define part of project that should not be distributed in the package
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# use_build_ignore("Development")


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Adding package dependencies using usethis::use_package()
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# use_dev_package("dsCCPhosClient", remote = "github::BastianReiter/dsCCPhosClient")
# use_package("DT")
# use_package("gt")
# use_package("shiny")
# use_package("shinyjs")
# use_package("shiny.router")
# use_package("shiny.semantic")
# use_package("shiny.worker")
# use_package("stringr")
# use_package("waiter")



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Adding general R script files
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# use_r("StartCCPhosApp")
# use_r("UIComponent")
# use_r("ServerComponent")

# use_r("DataFrameToHtmlTable.R")


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Adding UI Specifications
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# use_r("UIPageAnalyze")
# use_r("UIPageExplore")
# use_r("UIPageExport")
# use_r("UIPagePrepare")
# use_r("UIPageStart")


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Adding Shiny modules
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# use_r("ModConnectionStatus")
# use_r("ModInitialize")
# use_r("ModLogin")
# use_r("ModMessages")
# use_r("ModProcessingTerminal")
# use_r("ModServerWorkspaceMonitor")

