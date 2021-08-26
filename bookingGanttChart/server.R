#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# con<-dbConnect(RSQLite::SQLite(),
#                paste0(here(),'/','equipment.db'))

palette1 <- as.data.table(colorRampPalette(brewer.pal(8, "Dark2"))(12))
palette2<- as.data.table(colorRampPalette(brewer.pal(12, "Paired"))(18))
mycolors<-bind_rows(palette1,palette2) 
mycolors$user_id<-seq(1:nrow(mycolors))


booking<-tbl(pool,'tbl_booking') %>% as_tibble()
dept<-tbl(pool,'tbl_dept')%>% as_tibble()
equipType<-tbl(pool,'tbl_equipType')%>% as_tibble()
equip<-tbl(pool,'tbl_equipment')%>% as_tibble()
instit<-tbl(pool,'tbl_instit')%>% as_tibble()
user<-tbl(pool,'tbl_user')%>% as_tibble()
equipAlloc<-tbl(pool,'tbl_equipAllocation')%>% as_tibble()

onStop(function() {
  poolClose(pool)
})

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

output$ganttChart<-renderPlotly({
  

    
    data<- booking %>% 
        left_join(user,by='user_id') %>%
        left_join(equipAlloc, by = 'booking_id') %>%
        full_join(equip, by='equip_id') %>%
        left_join(equipType, by='type_id') %>% 
        as.data.table() %>%
        left_join(mycolors,by='user_id', copy=T) %>% 
        # mutate(start_date=dmy(start_date),
        # end_date=dmy(end_date)) #%>% 
        mutate(days=difftime(end_date,start_date)) %>%
        mutate(tooltips = paste("Booking ID: ",booking_id,"<br>",
                                "Redcap ID: ", redcap_id,"<br>",
                                "Start: ",start_date, "<br>",
                                "End: ",end_date, "<br>",
                                "User: ",fullName
        )) %>% 
        #filter(!is.na(booking_id)) %>%
        #rename(start=start_date, end=end_date,group=equip_name, event=fullName,color=V1)%>%
        select(c('Booking ID' = booking_id,
                 event=fullName,
                 start=start_date,
                 end = end_date,
                 group = equip_name,
                 color = V1,
                 days, 
                 tooltips,
                 equip_order)) %>% 
        #select(c(8,11,4,5,10,16,14,15,12)) %>%
        arrange(equip_order) %>%
        vistime(col.event="event",
                   col.group="group",
                   col.start="start",
                   col.end="end",
                   col.tooltip = "tooltips",
                   col.color = "color",
                   show_labels = FALSE,
                   linewidth = 20,
                   title = "Marine Science Equipment Bookings") 

    
    
    data %>%
    layout(
      yaxis=list(fixedrange=TRUE,
                 size = 50
                 ),
    xaxis=list(
       rangeselector = list(
        buttons = list(
          list(
            count = 1,
            label = "1 mo",
            step = "month",
            stepmode = "backward"),
                    list(
            count = 3,
            label = "3 mo",
            step = "month",
            stepmode = "backward"),
                    list(
            count = 6,
            label = "6 mo",
            step = "month",
            stepmode = "backward"),
                    list(
            count = 12,
            label = "1 yr",
            step = "month",
            stepmode = "backward")
          )
        ),
       range=c(Sys.Date()-days(7),max(booking$end_date)),
       rangeslider = list(type = "date")
    )
    )
})

})
