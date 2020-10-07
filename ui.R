**User Interface for the Water Vulnerability Explorer (WaVE)**

library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)

    ui <- dashboardPage( #build dashboard page
      
        dashboardHeader(title = "Midwestern Water Shutoffs", #title
                        titleWidth = 300), #header width
        
        dashboardSidebar( 
          width = 300,
         
          #Variable Selector Input
          
          wellPanel(
            
            "Display Variable",
            
            selectInput("map_var", 
                        label = "Select Independent Variable",
                        choices = c('Total Shutoffs',   #menu options 
                                    'Shutoffs Per 1000 Residents',
                                    'Median Household Income',
                                    'Household Poverty Rate',
                                    'Percent Renting',
                                    'Percent Non-White'
                        ))
            
          ),
          
          wellPanel( #second panel for Regression Model variables 
          
          "Regression Model Variables", 
            
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
          "Data for this project were collected through public records requests by American Public Media, and analyzed by Emmett McKinney at MIT-DUSP. Learn more at http://americanwatershutoffs.mit.edu/.",
          value = "About")
          )
        )
      )
    
        

        
    
    
    
  
    

