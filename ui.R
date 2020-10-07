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
library(dashboardthemes)
library(leaflet)
library(DT)

# Define UI for application that draws a histogram

    ui <- dashboardPage(skin = 'blue',
      
        dashboardHeader(title = strong("Water Vulnerability Explorer (WaVE)"),
                        titleWidth = 300),
        
        dashboardSidebar(
          
          width = 300,
          
          wellPanel(style = "color:black",
                            
          em(
            tags$p(strong("Water is a human right.")),
            tags$p("But for low-income communities, it is not a guarantee. Rising water prices and aging infrastructure can leave many without access.",
            tags$p("This map presents water disconnections from 2007-2019 in Cleveland, OH.")       
          )  
          )
          ),
          
          
          #Variable Selector Input
          
          wellPanel(style = "color:black,
                             padding-top: 12 px;
                             padding-bottom: 10 px",
            
  
          selectInput("map_var_choice", 
                        label = strong("Select Map Variable"),
                        choices = c('Total Shutoffs',
                                    'Shutoffs Per 1000 Residents',
                                    'Median Household Income',
                                    'Household Poverty Rate',
                                    'Percent Renting',
                                    'Percent Non-White'
                        ))
    
          ),
          
          wellPanel(style = "color:black,
                             padding-top: 12 px;
                             padding-bottom: 10 px",
          
          selectInput("dep_var_choice", 
                      label = strong("Select Dependent Variable"),
                      choices = c("Total Shutoffs", 
                                  "Shutoffs Per 1000 Residents",
                                  "Log-adjusted Total Shutoffs"
                      ), selected = 'Shutoffs Per 1000 Residents'),
          
          selectInput("ind_var_choice", 
                    label = strong("Select Independent Variable"),
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
          
          
          shinyDashboardThemes(theme = 'blue_gradient'),
          
          tabsetPanel(
          
          tabPanel("Map", 
                   wellPanel(style = "padding-top: 12 px;
                                      padding-bottom: 10 px",
                   leafletOutput("mymap")
                   ),
                   
                   wellPanel(
                   
                   strong(htmlOutput("hist_title")),
                   
                   br(),
                   
                   plotOutput("hist")
                   ),
                   
                   value = "Map"),
                  # 
          tabPanel("Model", style = "padding-top: 12 px;
                            padding-bottom: 10 px",
                   p(''),
                   
                   strong(p("Plot")),
                   
                   wellPanel(
                                        
                   plotOutput("scatter")
                   ),
                   
                   strong(p("Summary Statistics")),
                   
                   fluidRow(
                     column(6, wellPanel(style = "padding-bottom: 10 px",
                       p(textOutput("print_ind_var")),
                   verbatimTextOutput("ind_stats", placeholder = FALSE))),
          
                      column(6, wellPanel(style = "padding-bottom: 10 px",
                        p(textOutput("print_dep_var")),
                   verbatimTextOutput("dep_stats", placeholder = FALSE))),
                   ),
                   
                   p(strong("Regression Results")),
                   
                   verbatimTextOutput("reg", placeholder = FALSE),
                  value = "Model"),
          
          tabPanel("The Data", DT::dataTableOutput("mytable")),
          
          tabPanel("About",
          p(''),
          p("Data for this project were collected through public records requests by", a("American Public Media", href = "https://www.apmreports.org/story/2019/02/07/great-lakes-water-shutoffs"), "and analyzed by Emmett McKinney."),
          p("Learn more at the", a("American Water Shutoffs", href = "http://americanwatershutoffs.mit.edu/"), "blog."),
          value = "About")
          
            
          )
        )
      )
  
  
        
    
    
    
  
    

