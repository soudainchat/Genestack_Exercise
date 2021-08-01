
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
                          "<p>", df[df$go_term_label== input$inpt | substr(df$go_term_label, 1, nchar(input$inpt)) == input$inpt, "gene_symbol"], "</p>", 
                          "<b>", " Synonyms: ", "</b>", 
<<<<<<< HEAD
                          "<p>", df[df$go_term_label== input$inpt | substr(df$go_term_label, 1, nchar(input$inpt)) == input$inpt, "gene_synonyms"],"</p>",
                          "<b>", " Ontology Term: ", "</b>", 
                          "<p>", df[df$go_term_label== input$inpt | substr(df$go_term_label, 1, nchar(input$inpt)) == input$inpt, "go_term_label"],"</p>", 
=======
                          "<p>", df[df$go_term_label== input$inpt, "gene_synonyms"],"</p>",
                          "<b>", " Ontology Term: ", "</b>", 
                          "<p>", df[df$go_term_label== input$inpt, "go_term_label"],"</p>", 
>>>>>>> 6d8703da9116d7a6f59c8ec026bb7bf50fee23fe
                          "<br>" ))
        }
        
    }) 
}

shinyApp(ui = ui, server = server)
