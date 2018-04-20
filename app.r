#Still currently in testing and not in any way finished

#When using this for your own use it's better to retype it than copy and paste so i highly suggest it

#Before you do anything you will need to install a few packages in order for things to work
#All you need to do is type these thing's below (Without the #) in the R console
#install.packages("shiny")
#install.packages("shinyjs)
#install.packages("leaflet")
#install.packages("jsonlite")
#install.packages("shinydashboard")

#You will also need to load the libraries by typing these in the console then you will finally be able to use it
library(shiny)
library(shinyjs)
library(leaflet)
library(jsonlite)
library(shinydashboard)

#UI-------------------------------------------------------------------------------------------------------------------------------------
#Sets up the descriptions in the UI
#You can change the parameters

#the includeCSS is not a note, it will be needed to be there for things to run
#Title is self explanatory
#sliderInput is how much tracked items do you want to see (The 3 number parameters by order is minimum,maximum,default)
#Leaflet creates the map

ui <- fluidPage( 
  #includeCSS("styles.css"),
  dashboardHeader(title = "Live tracker"),
  sliderInput("count","Amount",1,8,2),
  leafletOutput("mymap") 
)

#Server---------------------------------------------------------------------------------------------------------------------------------
#
server <- function(input, output, session) 
{
  #jsonlite loaded again to make sure
  library(jsonlite)
  
  #jsLandTransport will read from a json in a website and then landTransport will take jsLandTransport's information and put it into
  #a data frame, the website json that is used for this is written below (The parameter for the website cannot be changed unless you
  #make adjustment to the code)
  jsLandTransport = fromJSON("http://api.metro.net/agencies/lametro/vehicles/")
  landTransport <- as.data.frame(jsLandTransport)
  
  #Displaying the content of landTransport
  landTransport
  
  #Yes
  values <- reactiveValues()
  
  #This will make the map display showing the locations and details on each tracked land transports
  output$mymap <- renderLeaflet({
   leaflet(data = landTransport[1:input$count,]) %>% addTiles() %>%
     addMarkers(~items.longtitude, ~items.latitude, popup = ~as.character(items.heading), label=~as.character(items.id))
  
  #Observes the API and make changes
  observe({
    invalidateLater(1000, session)
    landTransport = fromJSON("http://api.metro.net/agencies/lametro/vehicles/")
  })
   
})

}
shinyApp(ui, server)
