#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(leafem)
library(rsconnect)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("SSSIs and Settlements in Cumbria"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(h1("Overlap between settlements and SSSIs in Cumbria"),
                p("There is a large amount of overlap between sites of special scientific interest (SSSIs) and settlements in Cumbria, UK."),
                h2("The distribution of settlements and SSSIs in Cumbria"),
            leafletOutput(outputId = "cumbria_map"),
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    # output$distPlot <- renderPlot({
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white')
    # })
    output$cumbria_map <- renderLeaflet({leaflet() %>% 
            addProviderTiles(providers$Stamen.TerrainBackground, group = "Terrain (default)") %>% 
            addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
            addTiles(group = "Towns and villages") %>%
            addPolygons(data = settlements.ll, color = "red", fillColor = "red", fillOpacity = 0.5, group = "Settlements") %>%
            addPolygons(data = sssi.ll, color = "blue", fillColor = "blue", fillOpacity = 0.5, group = "SSSIs") %>%
            addLayersControl(
                baseGroups = c("Terrain (default)", "Satellite", "Towns and villages"), 
                overlayGroups = c("SSSIs", "Settlements"),
                options = layersControlOptions(collapsed = TRUE)) %>%
            setView(lat = 54.5471, lng=-3.1687, zoom=10) %>%
            addLegend("bottomright",
                      colors = c("red", "blue"),
                      labels = c("Settlements", "SSSIs"),
                      title = "Features",
                      opacity = 1)
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
