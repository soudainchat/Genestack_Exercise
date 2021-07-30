
library(shiny)
library(dplyr)
df <- read.csv("Homo+sapiens.csv")

ui <- fluidPage(
    titlePanel("Genestack Exercise"),
    sidebarPanel(
        selectizeInput("inpt", "Enter gene symbol or gene ontology term:", 
                       choices = NULL)
    ),
    mainPanel(
        helpText('Information found:'),
        htmlOutput("smth")
    )
)

server <- function(input, output, session) {
    updateSelectizeInput(session, "inpt", choices = c(df$gene_symbol, df$go_term_label), 
                         options = list(placeholder = 'start writing here...', create=FALSE), 
                         selected = FALSE,
                         server = TRUE)
    
    output$smth <- renderText({
        
        if (input$inpt == ""){
            paste( )
        }
        
        else if (input$inpt %in% df$gene_symbol){
            unique(paste0("<p>", "<b>", "Gene Symbol: ", "</b>", input$inpt, "</p>",
                          "<p>","<b>", "Gene Synonyms: ","</b>", df[df$gene_symbol == input$inpt, "gene_synonyms"], "</p>",
                          "<p>","<b>", "Gene Ontology Term: ","</b>", df[df$gene_symbol == input$inpt, "go_term_label"], "</p>"))
        }
        else if (input$inpt %in% df$go_term_label){ 
            unique(paste0("<b>", "Associated gene: ", "</b>", 
                          "<p>", df[df$go_term_label== input$inpt, "gene_symbol"], "</p>", 
                          "<b>", " Synonyms: ", "</b>", 
                          "<p>", df[df$go_term_label== input$inpt, "gene_synonyms"],"</p>",
                          "<b>", " Ontology Term: ", "</b>", 
                          "<p>", df[df$go_term_label== input$inpt, "go_term_label"],"</p>", 
                          "<br>" ))
        }
        
    }) 
}

shinyApp(ui = ui, server = server)
