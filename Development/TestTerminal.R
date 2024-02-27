
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#      CCPhos App Test Terminal
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(CCPhosApp)

TestData_Frankfurt <- readRDS("../dsCCPhos/Development/Data/RealData/CCPRealData_Frankfurt.rds")

StartCCPhosApp(TestData = TestData_Frankfurt)



if (interactive()) {
 library(shiny)
 library(shiny.semantic)
 ui <- semanticPage(
 title = "Steps Example",
 shiny::tagList(
   h2("Steps example"),
   shiny.semantic::steps(
     id = "steps",
     steps_list = list(
         single_step(
           id = "step_1",
           title = "Step 1",
           description = "It's night?",
           icon_class = "moon"
         ),
         single_step(
           id = "step_2",
           title = "Step 2",
           description = "Order some food",
           icon_class = "bug"
         ),
         single_step(id = "step_3",
                     title = "Step 3",
                     description = "Feed the Kiwi",
                     icon_class = "kiwi bird"
                   )
     )
   ),
   h3("Actions"),
   shiny.semantic::action_button("step_1_complete", "Make it night"),
   shiny.semantic::action_button("step_2_complete", "Call the insects"),
   shiny.semantic::action_button("step_3_complete", "Feed the Kiwi"),
   shiny.semantic::action_button("hungry_kiwi", "Kiwi is hungry again"),
 )
)

 server <- function(input, output, session) {
   observeEvent(input$step_1_complete, {
     toggle_step_state("step_1")
   })

   observeEvent(input$step_2_complete, {
     toggle_step_state("step_2")
   })

   observeEvent(input$step_3_complete, {
     toggle_step_state("step_3")
   })

   observeEvent(input$hungry_kiwi, {
     toggle_step_state("step_1", FALSE)
     toggle_step_state("step_2", FALSE)
     toggle_step_state("step_3", FALSE)
   })

 }

 shiny::shinyApp(ui, server)
}



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



if (interactive()) {
  library(shiny)
  library(shiny.semantic)

  ui <- function() {
    shinyUI(
      semanticPage(
        title = "My page",
        menu(menu_item("Menu"),
             dropdown_menu(
               "Action",
               menu(
                 menu_header(icon("file"), "File", is_item = FALSE),
                 menu_item(icon("wrench"), "Open"),
                 menu_item(icon("upload"), "Upload"),
                 menu_item(icon("remove"), "Upload"),
                 menu_divider(),
                 menu_header(icon("user"), "User", is_item = FALSE),
                 menu_item(icon("add user"), "Add"),
                 menu_item(icon("remove user"), "Remove")),
               class = "",
               name = "unique_name",
               is_menu_item = TRUE),
             menu_item(icon("user"), "Profile", href = "#index", item_feature = "active"),
             menu_item("Projects", href = "#projects"),
             menu_item(icon("users"), "Team"),
             menu(menu_item(icon("add icon"), "New tab"), class = "right"))
      )
    )
  }
  server <- shinyServer(function(input, output) {})
  shinyApp(ui = ui(), server = server)
}



