#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(ggplot2)
library(sf)
library(dplyr)
library(DT)
library(RColorBrewer)

setwd("/Users/emmettmckinney/Documents/CodeAcademy/Water_Shutoffs_App")

shutoffs <- st_read("data/cleveland_tract_analysis.geojson")

#set color scheme for map

#Define server logic required to draw a histogram
 
shinyServer(function(input, output) {

map_var <- reactive({
        switch(input$map_var_choice,
               "Total Shutoffs" = shutoffs$n_shutoffs_tract,
               "Shutoffs Per 1000 Residents" = shutoffs$shutoffs_1000p,
               #'Median Household Income' = shutoffs$MHI,
               'Household Poverty Rate' = shutoffs$Prc_HH_Pov * 100,
               'Percent Renters' = shutoffs$Prc_Rnt * 100,
               'Percent Non-White' = shutoffs$Prc_NonW * 100) 
    })
    
    
dep_var <- reactive({
            switch(input$dep_var_choice,
                   "Total Shutoffs" = shutoffs$n_shutoffs_tract,
                   "Shutoffs Per 1000 Residents" = shutoffs$shutoffs_1000p,
                   "Log-adjusted Total Shutoffs" = shutoffs$log_shut
                   ) 
        })

ind_var <- reactive({
   switch(input$ind_var_choice,
          #'Median Household Income' = shutoffs$MHI,
          'Household Poverty Rate' = shutoffs$Prc_HH_Pov * 100,
          'Percent Renters' = shutoffs$Prc_Rnt * 100,
          'Percent Non-White' = shutoffs$Prc_NonW * 100,
          'Log-adjusted MHI' = shutoffs$log_MHI,
          'Log-adjusted % Non-White' = shutoffs$log_Prc_NonW)
    
})

        #Basic Linear Regression Model
        
lm1 <- reactive({lm(dep_var() ~ ind_var(), data = shutoffs)})

        #Results Tables
        output$print_ind_var <- renderText({ 
            paste("Independent:", input$ind_var_choice)
            })
        
        output$print_dep_var <- renderText({ 
            paste("Dependent:", input$dep_var_choice)
        })
        
        output$reg <- renderPrint({summary(lm1())})
        
        output$scatter <- renderPlot({ggplot(shutoffs, aes(x = ind_var(), y = dep_var())) + 
                                                 geom_point() +
                                                 stat_smooth(method = "lm", col = "deepskyblue4") +
                                                    xlab(paste0(input$ind_var_choice)) +
                                                    ylab(paste0(input$dep_var_choice))})
        
        #Create Histogram
        
        output$hist <- renderPlot({
                ggplot(shutoffs, aes(x=map_var(), fill = Maj_Minority, color = Maj_Minority)) +
                geom_histogram(position = "identity", alpha = 0.5, bins = 50) + 
                scale_fill_discrete(labels = c("Majority White", "Majority Non-White")) +
                ylab("Number of Census Tracts") +
                xlab(paste0(input$map_var_choice))
            })
        
        #Title for Histogram
        output$hist_title <- renderUI({
                str1 <- paste("Histogram of", input$map_var_choice)
                str2 <- paste("by Racial Makeup (Census Tract)")
                HTML(paste(str1, str2))
        })
        
        #Add map element 
        output$mymap <- renderLeaflet({
            
        pal <- colorBin(
                palette = "Blues",
                domain = c(min(map_var()), max(map_var()),
                           bins=10))
            
          leaflet(st_transform(shutoffs, 4326)) %>% 
                addProviderTiles(providers$Stamen.TonerLite) %>%  #tile layer 
                addPolygons(smoothFactor = 0.2, fillOpacity = 0.8, #style polygons 
                            color = "#fff", weight = 1,  
                            fillColor = ~pal(map_var())) %>%
                addLegend("bottomright", pal = pal, values = ~map_var(),
                        title = paste0(input$map_var_choice, " (2009 - 2017)"),
                        opacity = 1
              )
          })

        #summary stats for the city 
        output$dep_stats <- renderPrint({summary(dep_var())})
        output$ind_stats <- renderPrint({summary(ind_var())})
        
        #Data Table
        output$mytable = DT::renderDataTable({
            shutoffs %>% select(-geometry)
        })


       
           
}) ## END 
       

        
    
        
        
   


