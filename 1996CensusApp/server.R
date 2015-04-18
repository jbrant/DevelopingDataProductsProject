library(rCharts)
library(data.table)

options(RCHART_WIDTH = 500)

census.data <- read.csv(
  file = './data/adult.data', 
  #file = 'adult.data',
  header = F, 
  strip.white = T)

## Remove final weight and education number variable
census.data <- census.data[ ,-c(3,11,12)]

## Rename columns
names(census.data) <- c(
  'Age',
  'WorkArrangement',
  'Education',
  'EducationLevel',
  'MaritalStatus',
  'Occupation',
  'Relationship',
  'Race',
  'Sex',
  'WorkHoursPerWeek',
  'NativeCountry',
  'IncomeBracket')

subsetCensusData <- function(sex, min.age, max.age) {
  if (sex == 'Both') {
    subset(
      census.data, 
      Age >= min.age & Age <= max.age)
  }
  else {
    subset(
      census.data, 
      Sex == sex & Age >= min.age & Age <= max.age) 
  }  
}

shinyServer(function(input, output) {  
  
  ## Render the occupation distribution
  output$occupation <- renderChart2({
    occupation.chart <- hPlot(~ Occupation, 
                              data = subsetCensusData(
                                input$gender.selection, 
                                input$age.range.selection[1], 
                                input$age.range.selection[2]), 
                              type = 'pie')
    occupation.chart$title(text = 'Occupation Distribution')
    occupation.chart
  })
  
  ## Render the work arrangement distribution
  output$work.arrangement <- renderChart2({
    work.arrangement.chart <- hPlot(~ WorkArrangement, 
                                    data = subsetCensusData(
                                      input$gender.selection, 
                                      input$age.range.selection[1], 
                                      input$age.range.selection[2]), 
                                    type = 'pie')
    work.arrangement.chart$title(text = 'Work Arrangement Distribution')
    work.arrangement.chart
  })
  
  ## Render the Average Hours per Occupation bar chart
  output$avg.hours.per.occupation <- renderChart2({
    
    mean.hours.per.occupation <- as.data.table(subsetCensusData(
      input$gender.selection, 
      input$age.range.selection[1], 
      input$age.range.selection[2]))[
        ,list(MeanHours = round(mean(WorkHoursPerWeek), 2)), by=Occupation]
    
    avg.hours.per.occupation.chart <- hPlot(MeanHours ~ Occupation, 
                                            data = mean.hours.per.occupation, 
                                            type = 'bar')
    avg.hours.per.occupation.chart$title(text = 'Mean Hours Worked per Week by Occupation')
    avg.hours.per.occupation.chart
  })
  
  ## Render Maximum Education Attainment bar chart
  output$max.education <- renderChart2({
    
    max.education <- as.data.table(subsetCensusData(
      input$gender.selection, 
      input$age.range.selection[1], 
      input$age.range.selection[2]))[
        order(EducationLevel),
        list(Total = length(EducationLevel)), 
        by=Education]
    
    max.education$Education <- factor(
      max.education$Education, 
      levels = max.education$Education, 
      ordered = TRUE)
    
    max.education.chart <- hPlot(Total ~ Education, 
                                 data = max.education, 
                                 type = 'bar')
    max.education.chart$title(text = 'Maximum Educational Attainment')
    max.education.chart
  })
  
  ## Render Marital Status pie chart
  output$marital.status <- renderChart2({
    marital.status.chart <- hPlot(~ MaritalStatus, 
                              data = subsetCensusData(
                                input$gender.selection, 
                                input$age.range.selection[1], 
                                input$age.range.selection[2]), 
                              type = 'pie')
    marital.status.chart$title(text = 'Marital Status Distribution')
    marital.status.chart
  })
  
  ## Render Native Country pie chart
  output$native.country <- renderChart2({
    native.country.chart <- hPlot(~ NativeCountry, 
                                  data = subsetCensusData(
                                    input$gender.selection, 
                                    input$age.range.selection[1], 
                                    input$age.range.selection[2]), 
                                  type = 'pie')
    native.country.chart$title(text = 'Native Country Distribution')
    native.country.chart
  })
  
  ## Render Race pie chart
  output$race <- renderChart2({
    race.chart <- hPlot(~ Race, 
                                  data = subsetCensusData(
                                    input$gender.selection, 
                                    input$age.range.selection[1], 
                                    input$age.range.selection[2]), 
                                  type = 'pie')
    race.chart$title(text = 'Race Distribution')
    race.chart
  })
})