#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)

# Define UI for application that draws a histogram

    ui <- dashboardPage(
      
        dashboardHeader(title = "Midwestern Water Shutoffs",
                        titleWidth = 300),
        
        dashboardSidebar(
          width = 300,
          
         
          #Variable Selector Input
          
          wellPanel(
            
            "Display Variable",
            
            selectInput("map_var", 
                        label = "Select Independent Variable",
                        choices = c('Total Shutoffs',
                                    'Shutoffs Per 1000 Residents',
                                    'Median Household Income',
                                    'Household Poverty Rate',
                                    'Percent Renting',
                                    'Percent Non-White'
                        ))
            
          ),
          
          wellPanel(
          
          "Regression Model Variable",
            
          selectInput("var", 
                      label = "Select Dependent Variable",
                      choices = c("Total Shutoffs", 
                                  "Shutoffs Per 1000 Residents",
                                  "Log-adjusted Total Shutoffs"
                      ), selected = 'Shutoffs Per 1000 Residents'),
          
          selectInput("var2", 
                    label = "Select Independent Variable",
                     choices = c('Median Household Income',
                                 'Household Poverty Rate',
                                 'Percent Renters',
                                 'Percent Non-White',
                                 'Log-adjusted MHI',
                                 'Log-adjusted % Non-White'
          ), selected = 'Household Poverty Rate')
        )
      ),
           
        dashboardBody(
          
          tabsetPanel(
          
          tabPanel("Map", 
                   leafletOutput("mymap"),
                   
                   "Histogram of Independent Variable, by Majority-Minority Population",
                   
                   plotOutput("hist"),
                   
                   
                   value = "Map"),
                  # 
          tabPanel("Model", 
                   
                   plotOutput("scatter"),
                   
                   "Summary Statistics (Independent Variable by Census Tract)",
                   
                   verbatimTextOutput("stats", placeholder = FALSE),
                   
                   "Regression Model Results",
                   
                   verbatimTextOutput("reg", placeholder = FALSE),
                  value = "Model"),
          
          tabPanel("The Data", DT::dataTableOutput("mytable")),
          
          tabPanel("About",
          "Data for this project were collected through public records requests by American Public Media, and analyzed by the Science Impact Collaborative at MIT-DUSP.",
          value = "About")
          )
        )
      )
    
        

        
    
    
    
  
    

