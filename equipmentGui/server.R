#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


shinyServer(function(input, output, session) {    

# Start Create New Booking Tab --------------------------------------------

    ## Generate user table and output it to the UI -----------------------------
     
    userTable<-reactive({
        
        user() %>% 
            left_join(dept(), by = 'dept_id') %>% 
            as_data_frame() %>% 
            select(UserID = user_id,User = fullName,Department=dept_name, Phone = contactNo, email = email ) %>%
            arrange(UserID)
      })
    
    output$userTable<-DT::renderDataTable(userTable(),
                                          server=FALSE,
                                          selection='single',
                                          rownames=FALSE)

    ## Get the selected user from the User Table in the UI ---------------------

    
    userId=reactive({
        
        selectedUser<-input$userTable_rows_selected
        
        userTable()[selectedUser,1]
        })
    
    # selected<-input$bookingTableEquip_rows_selected#Get row ID
    # bookingTable()[selected,1]

    ## Get the Manual inputs and dates from the UI -----------------------------

        ### Start Date Input ---------------------------------------------------

    
    stDate<-reactive({
        input$bookingStDate
    })
        ### End Date Input -----------------------------------------------------  
    edDate<-reactive({
        input$bookingEdDate
    })

        ### Field Plan Text Input-----------------------------------------------    
    fieldPlan<-reactive({
        input$fieldPlan
    })


        ### Comments Text Input ------------------------------------------------

    
    bookingComments<-reactive({
        input$bookingComments
    })
    
    output$bookingData<-renderTable(
        tibble(
                user_id = as.integer(userId()),
                start_date = as.character(stDate()),
                end_date = as.character(edDate()),
                field_plan = fieldPlan(),
                comments = bookingComments()
                )
    )


    ## Write the booking data to the Database tbl_booking-----------------------

        

    observeEvent(input$saveBooking,{

        ### Create a tibble of the data ----------------------------------------

        
        bookingDat<-tibble(
            user_id = as.integer(userId()),
            start_date = as.character(stDate()),
            end_date = as.character(edDate()),
            field_plan = fieldPlan(),
            comments = bookingComments()
            )

        ### Write the tibble to the database tbl_booking -----------------------

        
        DBI::dbWriteTable(
            conn = con,
            name = 'tbl_booking',
            value = bookingDat,
            overwrite = FALSE,
            append = TRUE
            )

        ###Create an alert that shows the data has been written to the data ----

    
        show_alert(
            title = 'saved',
            text = ' Your Data has ben saved',
            type = 'sucess',
            closeOnClickOutside = TRUE,
            showCloseButton = TRUE
            )
        })


    ## Reset the form ----------------------------------------------------------

    observeEvent(input$reset,{
        reset('newBookingForm')
    
    })


    ## Create  Datatable of bookings -------------------------------------------



        ### Interogate tables and join with other tables -----------------------

    bookingTable<-reactive({
        
        booking() %>% 
            left_join(user(), by = 'user_id') %>% 
            left_join(dept(), by = 'dept_id') %>% 
            as_data_frame() %>% 
            select('Booking ID' = booking_id,User = fullName,Department=dept_name, 'Start Date'=start_date, 'End Date'=end_date ) %>%
            arrange(desc('Booking ID'))
        
    })


        ### Output Booking table to UI -----------------------------------------
    output$bookingTable<-DT::renderDataTable(
        bookingTable(),
        server=FALSE,
        selection='single',
        rownames=FALSE
        
    )


# Start of Allocate Equipment Tab ----------------------------------------------

    ## Output booking table to top of Allocate Equipment form ------------------

  
    output$bookingTableEquip<-DT::renderDataTable(
        
        bookingTable(),
        server=FALSE,
        selection='single',
        rownames=FALSE,
        caption = 'List of Bookings'
        
    )

    ## Get Booking information from selected line in Booking Table -------------
    bookingID=reactive({
        
        selected<-input$bookingTableEquip_rows_selected#Get row ID
        bookingTable()[selected,1]#use row ID to get rest of information for that row
        
    })


    ## Get equipment selection from form and convert to a table -----------------

        ### Get equipment selections from UI ----------------------------------------

    
    equipSelection<-reactive({
        data.table::data.table(
            'SBE19 1469'=input$sbe19_1469,
            'SBE19 2267'=input$sbe19_2267,
            'SBE25 0352'=input$sbe25_0352,
            'Rosette'=input$rosette,
            'Niskin Water Bottles'=input$niskinBottles,
            'LI-193SA'=input$li193,
            'Concerto'=input$concerto,
            'XR 620'=input$xr620,
            'Maestro'=input$maestro,
            'XR 420 18263'=input$xr420_18263,
            'XR 420 18264'=input$xr420_18264,
            'XR 420'=input$xr420,
            'Clamshell Grab'=input$clamshell,
            'Petite Ponar'=input$ponarPetite,
            'Standard Ponar'=input$ponarStd,
            'Box Corer'=input$box,
            'Gravity Corer'=input$gravity,
            'Piston Corer'=input$piston
        ) %>% 


        ### Pivot to a long table and add instrment IDs -----------------------------

            
            pivot_longer(cols = everything()) %>%
            mutate(equip_id = case_when(name == 'SBE19 1469' ~ as.integer(1),
                                           name == 'SBE19 2267' ~ as.integer(2),
                                           name == 'SBE25 0352' ~ as.integer(6),
                                           name == 'Rosette' ~ as.integer(5),
                                           name == 'Niskin Water Bottles' ~ as.integer(4),
                                           name == 'LI-193SA' ~ as.integer(12),
                                           name == 'Concerto' ~ as.integer(11),
                                           name == 'XR 620' ~ as.integer(19),
                                           name == 'Maestro' ~ as.integer(9),
                                           name == 'XR 420 18263' ~ as.integer(8),
                                           name == 'XR 420 18264' ~ as.integer(7),
                                           name == 'XR 420' ~ as.integer(10),
                                           name == 'Clamshell Grab'~as.integer(18),
                                           name == 'Petite Ponar'~as.integer(13),
                                           name == 'Standard Ponar'~ as.integer(17),
                                           name == 'Box Corer'~as.integer(14),
                                           name == 'Gravity Corer'~as.integer(15),
                                           name == 'Piston Corer'~as.integer(16)
                                           )
                   ) %>% 
            mutate(booking_id=as.integer(bookingID())) %>% 
            filter(value!=FALSE) %>% 
            select(booking_id, equip_id)
   
    })
    
    output$equipmentBookings<-(DT::renderDataTable(equipSelection()))
    
    observeEvent(input$saveEquipment,{
        


        DBI::dbWriteTable(#Write the tibble to the database
            conn = con,
            name = 'tbl_equipAllocation',
            value = equipSelection(),
            overwrite = FALSE,
            append = TRUE
        )
        
        show_alert(#show an alert once the data is saved
            title = 'saved',
            text = ' Your Data has ben saved',
            type = 'sucess',
            closeOnClickOutside = TRUE,
            showCloseButton = TRUE
        )
    })
    
    
    observeEvent(input$resetEquipment,{
        reset('equipmentForm')#reset the form
        
        show_alert(#show an alert once the data is saved
            title = 'reset',
            text = ' Your Form has been Reset',
            type = 'info',
            closeOnClickOutside = TRUE,
            showCloseButton = TRUE
        )
    })
    

# Start Booking Summary Table ---------------------------------------------
output$summaryBookingTable<-DT::renderDataTable(
    booking() %>%       
      left_join(user(), by = 'user_id') %>% 
      left_join(equipAllocation(), by = 'booking_id') %>% 
      left_join(equip(), by = 'equip_id') %>% 
      select('Booking ID'=booking_id,
             'Name' = fullName,
             'Start Date'= start_date,
             'End Date' = end_date,
             'Equipment' = equip_name,
             'Field Plan' = field_plan,
             'Contact No' = contactNo,
             'Comments' = comments
             )
      
    
)
    
    
    })
