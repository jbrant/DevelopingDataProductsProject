library(shiny)
library(rCharts)

shinyUI(fluidPage(
  
  ## Dashboard title
  headerPanel('1996 Census Demographics Dashboard'),
  
  #sidebarLayout(
  sidebarPanel(
    width = 3,
    
    helpText('Select gender and age range to display 
               demographic information.'),
    
    selectInput(inputId = 'gender.selection', 
                label = 'Choose a gender', 
                choices = list('Female', 'Male', 'Both'), 
                selected = 'Both'),
    
    sliderInput(inputId = 'age.range.selection', 
                label = 'Select an age range', 
                min = 17, 
                max = 90, 
                value = c(20, 80)),
    br(),
    helpText('Please scroll to the bottom of the dashboard 
             for more information regarding the visualizations 
             provided herein.')
  ),
  
  mainPanel(
    
    tabsetPanel(
      tabPanel('Professional',
               showOutput('occupation', lib = 'highcharts'),
               showOutput('work.arrangement', lib = 'highcharts'),
               showOutput('avg.hours.per.occupation', lib = 'highcharts'),
               showOutput('max.education', lib = 'highcharts')
      ),
      tabPanel('Personal', 
               showOutput('marital.status', lib = 'highcharts'),
               showOutput('native.country', lib = 'highcharts'),
               showOutput('race', lib = 'highcharts')
      )
    )
  )
))