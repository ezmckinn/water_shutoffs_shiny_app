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

setwd("/Users/emmettmckinney/Documents/CodeAcademy/Water_Shutoffs_App")

shutoffs <- st_read("data/cleveland_tract_year_shutoffs.geojson")

#set color scheme for map

#Define server logic required to draw a histogram
 
shinyServer(function(input, output) {

choose_map_var <- reactive({
        switch(input$map_var,
               "Total Shutoffs" = shutoffs$n_shutoffs_tract,
               "Shutoffs Per 1000 Residents" = shutoffs$shutoffs_1000p,
               'Median Household Income' = shutoffs$MHI,
               'Household Poverty Rate' = shutoffs$Prc_HH_Pov * 100,
               'Percent Renters' = shutoffs$Prc_Rnt * 100,
               'Percent Non-White' = shutoffs$Prc_NonW * 100) 
    })
    
    
choose_var <- reactive({
            switch(input$var,
                   "Total Shutoffs" = shutoffs$n_shutoffs_tract,
                   "Shutoffs Per 1000 Residents" = shutoffs$shutoffs_1000p,
                   "Log-adjusted Total Shutoffs" = shutoffs$log_shut
                   ) 
        })

choose_var_2 <- reactive({
   switch(input$var2,
          'Median Household Income' = shutoffs$MHI,
          'Household Poverty Rate' = shutoffs$Prc_HH_Pov * 100,
          'Percent Renters' = shutoffs$Prc_Rnt * 100,
          'Percent Non-White' = shutoffs$Prc_NonW * 100,
          'Log-adjusted MHI' = shutoffs$log_MHI,
          'Log-adjusted % Non-White' = shutoffs$log_Prc_NonW)
    
})


        #Basic Linear Regression Models
        
lm1 <- reactive({lm(choose_var() ~ choose_var_2(), data = shutoffs)})

        #output$scatter <- renderPrint({plot(lm1())})
        
        output$reg <- renderPrint({summary(lm1())})
        
        output$scatter <- renderPlot({ggplot(shutoffs, aes(x = choose_var_2(), y = choose_var())) + 
                                                 geom_point() +
                                                 stat_smooth(method = "lm", col = "red")})
        
        #Create Histogram
        
        output$hist <- renderPlot({
                ggplot(shutoffs, aes(x=choose_var(), fill = Maj_Minority, color = Maj_Minority)) +
                geom_histogram(position = "identity", alpha = 0.5, bins = 50) + 
                scale_fill_discrete(labels = c("Majority White", "Majority Non-White")) +
                ylab("Number of Census Tracts") +
                xlab(paste0(input$var))})
        
        #Add map element 
        output$mymap <- renderLeaflet({
            
        pal <- colorBin(
                palette = "Blues",
                domain = c(min(choose_map_var()), max(choose_map_var()),
                           bins=10))
            
          leaflet(st_transform(shutoffs, 4326)) %>% 
                addProviderTiles(providers$Stamen.TonerLite) %>%  #tile layer 
                addPolygons(smoothFactor = 0.2, fillOpacity = 0.8, #style polygons 
                            color = "#fff", weight = 1,  
                            fillColor = ~pal(choose_map_var())) %>%
                addLegend("bottomright", pal = pal, values = ~choose_map_var(),
                        title = paste0(input$var),
                        opacity = 1
              )
          })

        #summary stats for the city 
        output$stats <- renderPrint({summary(choose_var())})
        
        #Data Table
        output$mytable = DT::renderDataTable({
            shutoffs %>% select(-geometry)
        })
            
           
}) ## END 
       
            
        
    
        
        
   


