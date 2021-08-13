library(shiny)
library(shinyWidgets)
library(shiny)
library(shinyjs)
library(RSQLite)
library(tidyverse)
library(dbplyr)
library(here)
library(data.table)
library(lubridate)
library(DT)
library(DBI)




# Define server logic required to draw a histogram

  
  con<-dbConnect(RSQLite::SQLite(),
    paste0(here(),'/','equipment.db'))
  
  booking<-reactive({tbl(con,'tbl_booking') %>% as_data_frame()})
  #job<-reactive({tbl(con,'tbl_job') %>% as_data_frame()})
  dept<-reactive({tbl(con,'tbl_dept')%>% as_data_frame()})
  equipType<-reactive({tbl(con,'tbl_equipType')%>% as_data_frame()})
  equip<-reactive({tbl(con,'tbl_equipment')%>% as_data_frame()})
  instit<-reactive({tbl(con,'tbl_instit')%>% as_data_frame()})
  user<-reactive({tbl(con,'tbl_user')%>% as_data_frame()})
  equipAllocation<-reactive({tbl(con,'tbl_equipAllocation')%>% as_data_frame()})
  
 