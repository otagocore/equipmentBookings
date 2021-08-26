#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    fluidRow(
        
        
        column(width = 12, align = 'center',tags$h1(tags$div("University of Otago - Marine Science Department"
                                                             ,tags$br()
                                                             ,"Equipment Booking")
                                                    )
               )
        
    )
    ,
    fluidRow(

    plotlyOutput('ganttChart'))
    
    
))
