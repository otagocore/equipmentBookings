#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Define UI for application that draws a histogram
shinyUI(
    fluidPage(#Start Fluid Page
    
    tabsetPanel(#Start Tabset Panel

# Start of Booking Creation Tab----------------------------------------
   
        tabPanel("Create a New Booking",
                 useShinyjs(),
                 div(
                     id='newBookingForm',

## Datatable with a list of the Users --------------------------------------

                     
                 fluidRow(
                     column(width = 12,
                        DT::dataTableOutput("userTable")
                        )
                     ),
                 br(),
                 br(),

## Manual Data entry for dates, field plan etc -----------------------------


###  Booking Start and End dates --------------------------------------------

                 
                 fluidRow(
                     column(width = 3,
                        dateInput(inputId='bookingStDate',
                                       label = 'Start of the Booking')
                        ),#end column
                     
                     column(width = 3,
                        dateInput(inputId='bookingEdDate',
                                       label = 'End of the Booking')
                        ),#end column

### Text entry for Field Plan ID --------------------------------------------

                     
                     column(width = 3,
                        textInput(inputId='fieldPlan',
                                  label = 'Enter Field Plan',
                                  placeholder = 'Enter Feild Plan Id')
                        ),#end column
                     

                    column(width = 3,
                           textInput(inputId = 'redcapID',
                                     label = 'Redcap ID',
                                     placeholder = 'Enter Redcap ID')
                           )#end column
                      ),#end fluid row

### Text Entry for Booking comments -----------------------------------------

                 
                 fluidRow(
                     column(width = 12,
                        textAreaInput(inputId = 'bookingComments',
                                      label = 'Any additonal information',
                                      width = '100%',
                                      height = '100%',
                                      placeholder = 'Please enter any other information',
                                      resize = 'vertical')
                        )
                     )
        ),

## Create Save and Form Reset Buttons --------------------------------------

        
                 fluidRow(
                     column(width = 4,
                         actionBttn(
                             inputId = 'saveBooking',
                             label = 'Save Booking',
                             style = 'material-flat',
                             color = 'success'
                             )
                     ),
                     column(width = 4,
                            actionBttn(
                                inputId = 'reset',
                                label = 'Reset Form',
                                style = 'material-flat',
                                color = 'danger'
                            ))
                     ),
        br(),

## Output Datatable with the Bookings --------------------------------------

        
        fluidRow(
            column(width = 12,
                   DT::dataTableOutput("bookingTable")
            )
        ),
                 ),

        


# Start of Equipment Allocation Tab------------------------------------

    
    tabPanel("Allocate Equipment",
             useShinyjs(),
             div(
                 id='equipmentForm',
      
             fluidRow(
                 column(width = 12,
                        DT::dataTableOutput("bookingTableEquip")
                 )
             ),
           
           column(width = 12,h2('CTDs', align = 'center'),
             


## CTD Start ---------------------------------------------------------------


             
### CTDs Water Column Start --------------------------------------------------------------
        fluidRow(
                 column(width = 12, h3('CTD Water Column'),
                        column(width = 3,
                        checkboxInput(inputId = 'sbe19_1469',label = 'SBE19 1469', value = FALSE)
                                ),
                        column(width = 3,
                        checkboxInput(inputId = 'sbe19_2267',label = 'SBE19 2267', value = FALSE)
                                ),
                        column(width = 3,
                        checkboxInput(inputId = 'sbe25_0352',label = 'SBE25 0352', value = FALSE)
                                )
                        )
                 ),



### Water Sampling Start ----------------------------------------------------

            fluidRow(
                column(width = 12, h3('CTD Water Sampling'),
                       column(width = 3,
                       checkboxInput(inputId = 'rosette',label = 'Rosette', value = FALSE)
                       ),
                       column(width = 3,
                       checkboxInput(inputId = 'niskinBottles',label = 'Niskin Water Bottles', value = FALSE)
                       )
                )
            ),




### Light Measurement Start -------------------------------------------------

            fluidRow(
                column(width = 12, h3('CTD Light Measurement'),
                       column(width = 3,
                       checkboxInput(inputId = 'li193',label = 'LI-193SA', value = FALSE)
                       )
                       )
                )




        ),





## RBR Start ---------------------------------------------------------------


    column(width = 12, h2('RBR', align = 'center'),

### RBR Profiling Start -----------------------------------------------------
            fluidRow(
                column(width =12, h3('RBR Profiling'),
                       column(width = 3,
                              checkboxInput(inputId = 'concerto',label = 'Concerto', value = FALSE)
                              ),
                       column(width = 3,
                              checkboxInput(inputId = 'xr620',label = 'XR 620', value = FALSE)
                       )
                       )
                ),





### RBR Moored Start --------------------------------------------------------


        fluidRow(
            column(width =12, h3('RBR Moored'),
                   column(width = 3,
                          checkboxInput(inputId = 'maestro',label = 'Maestro', value = FALSE)
                          ),
                   column(width = 3,
                          checkboxInput(inputId = 'xr420_18263',label = 'XR 420 18263', value = FALSE)
                          ),
                   
                   column(width = 3,
                          checkboxInput(inputId = 'xr420_18264',label = 'XR 420 18264', value = FALSE)
                          ),
                   column(width = 3,
                          checkboxInput(inputId = 'xr420',label = 'XR 420', value = FALSE)
                          )
                   )
            ),



## Sediment Sampling Start ------------------------------------------------

column(width = 12, h2('Sediment Sampling', align = 'center'),
       

### Grabs Start -------------------------------------------------------------

       fluidRow(
           column(width = 12, h3('Grabs'),
                  column(width = 3,
                         checkboxInput(inputId = 'clamshell', label = 'Clamshell Grab', value = FALSE)
                         ),
                  column(width = 3, 
                         checkboxInput(inputId = 'ponarPetite', label = 'Petite Ponar', value = FALSE)
                         ),
                  column(width = 3, 
                         checkboxInput(inputId = 'ponarStd', label = 'Standard Ponar', value = FALSE)
                         )
                  )
           ),


### Corers Start ------------------------------------------------------------

        fluidRow(
            column(width = 12, h3('Grabs'),
                   column(width = 3,
                          checkboxInput(inputId = 'box', label = 'Box Corer', value = FALSE)
                   ),
                   column(width = 3, 
                          checkboxInput(inputId = 'gravity', label = 'Gravity Corer', value = FALSE)
                   ),
                   column(width = 3, 
                          checkboxInput(inputId = 'piston', label = 'Piston Corer', value = FALSE)
                          )
                   )
            )
),


## Comments ----------------------------------------------------------------
fluidRow(
    column(width = 12,
           textAreaInput(inputId = 'equipComments', 
                         label = 'Any Other Comments',
                         width = '100%',
                         height = '100%',
                         placeholder = 'Please enter any other information',
                         resize = 'vertical')
        
        
    )
)
),

## Save and Reset Form Buttons for Equipment-----------------------------------------------------------------
br(),
fluidRow(
    column(width = 4,
           actionBttn(
               inputId = 'saveEquipment',
               label = 'Save Booking',
               style = 'material-flat',
               color = 'success'
               )
           ),
    column(width = 4,
           actionBttn(
               inputId = 'resetEquipment',
               label = 'Reset Equipment',
               style = 'material-flat',
               color = 'danger'
               )
           )
    ),

fluidRow(
    column(width=12,
           DT::dataTableOutput('equipmentBookings'))
)
),
             
             fluidRow(
                 column(width = 12,
                     tableOutput(
                         'instrum')
                     )
                 )
),

# Start Booking Summery Table Panel ---------------------------------------


tabPanel('Booking Summary Table',
        useShinyjs(),
        div(id='summaryBookingTable',
        
            DT::dataTableOutput('summaryBookingTable')
            
        )
)
)#End Tabset panel
)#End Fluid Page
)
