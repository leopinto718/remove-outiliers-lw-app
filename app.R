## App for removing outliers from length-weight data
# Authors: Leonardo Mesquita Pinto, Ronaldo César Gurgel Lourenço and Jorge Iván Sánchez Botero

library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(shinyalert)
library(DT)

#########################################################################################
#############################     UI    #################################################
#########################################################################################

# Define UI for application that draws a histogram
ui <- fluidPage(
   
    #Set up shinyalert
    useShinyalert(),

    # Application title
    titlePanel("Remove outliers from length-weight data"),

    # Sidebar 
    sidebarLayout(
        sidebarPanel(
            fileInput("file", label = h3("Choose CSV File"),
                      accept = c(
                        'text/csv',
                        'text/comma-separated-values',
                        '.csv')),
            sliderInput("slider", label = h3("Range of standard residuals"), min = -5, 
                        max = 5, value = c(-2.5, 2.5), step = 0.25),
            actionButton("removeOutliers", label = "Remove outliers"),
            downloadLink('downloadOut', 'Download outliers'),
            downloadLink('downloadNoOut', 'Download data without outliers')
        ),

        # Show plots and tables
        mainPanel(
           textOutput("text"),
           plotlyOutput("plotOut"),
           plotlyOutput("plotNoOut"),
           DT::dataTableOutput("table")
           
        )
    )
)

#########################################################################################
#############################     SERVER   ##############################################
#########################################################################################


server <- function(input, output) {
  
# declaring reactive values that will receive dfs generated in the observeEvent()
  rResult <- reactiveValues(dfOut = 0, dfNoOut = 0)

#creating data frame that receive the csv uploaded by the user    
  df_products_upload <- reactive({
    inFile <- input$file
    if (is.null(inFile))
      return(NULL)
    df <- read.delim(inFile$datapath, header = TRUE,sep = ",", encoding = "UTF-8")
    return(df)
  })

  
  
#Button for removing outliers and plotting the data   
    observeEvent(input$removeOutliers,{
        var = df_products_upload()
        model<-lm(logW~logL, data= var)
        summary.model<-summary(model)
        r.stan<-rstandard(model)
        
        #generating reactive values for the range selected by the user      
        defined_range <- reactive({
          cbind(input$slider[1],input$slider[2])
        })
        
        output$values <- renderTable({
          sliderValues()
        })
        
       
         if(any(r.stan<=defined_range()[1]|r.stan>=defined_range()[2])){
           var2<-var[-which(r.stan<=defined_range()[1]|r.stan>=defined_range()[2]),]
           obsRemoved <- nrow(var) - nrow(var2)
           shinyalert(paste0(obsRemoved, "observations were removed!"))
        }
       else{
            shinyalert("No observation out of the range")
            return()
       }
       
        
           #Defining models      
            model_out<-lm(logW~logL, data=var)
            model_no_out<-lm(logW~logL, data=var2)
            
            outliers = var[which(r.stan<=defined_range()[1]|r.stan>=defined_range()[2]), ]
            dataNoOut = var[-which(r.stan<=defined_range()[1]|r.stan>=defined_range()[2]),]
            
            #Generating plots for the models
            
            dataWithOutlier = ggplot(var, aes(x=logL, y=logW)) + 
                              geom_point()+
                              geom_point(data=outliers, aes(x=logL, y=logW,text = row.names(outliers)), colour="red")+
                              geom_smooth(method=lm, se=FALSE)+
                              ggtitle("With outlier")
            
            dataWithoutOutlier =ggplot(var2, aes(x=logL, y=logW)) + 
                                geom_point()+
                                geom_smooth(method=lm, se=FALSE)+
                                ggtitle("Without outlier")
            
            class(dataWithoutOutlier)
           
            #Plotting data with outliers 
            output$plotOut <- renderPlotly({
              ggplotly(dataWithOutlier, tooltip = "text")
            })
            
            #Plotting data without outliers
            output$plotNoOut <- renderPlotly({
              ggplotly(dataWithoutOutlier, tooltip = NULL)
            })
            
            #Creating data frame with summary
            summary_out_treat<-data.frame(Individuals=c(nrow(var),nrow(var2)),r_squared=c(summary(model_out)$r.squared,summary(model_no_out)$r.squared),
                                          row.names=c("With outlier","Without outlier"))
            
            #Ploting summary in a table
            output$table <- DT::renderDataTable(DT::datatable({
                data = summary_out_treat
            }))
           
            rResult$dfOut <- outliers # MAKE THIS DATA AVAILABLE TO OTHER MODULE(S)
            rResult$dfNoOut <- dataNoOut# MAKE THIS DATA AVAILABLE TO OTHER MODULE(S)
            
          
        
        
    })



#Download button - outliers    
    output$downloadOut <- downloadHandler(
        filename = function() {
          paste('data-outliers', Sys.Date(), '.csv', sep='')
       },
        content = function(con) {
          write.csv(isolate(rResult$dfOut), con)
         }
       )   
        
#Download button - Data without outliers 
    output$downloadNoOut <- downloadHandler(
      filename = function() {
        paste('data-with-no-outliers', Sys.Date(), '.csv', sep='')
      },
      content = function(con) {
        write.csv(isolate(rResult$dfNoOut), con)
      }
    )      
    
}





# Run the application 
shinyApp(ui = ui, server = server)
