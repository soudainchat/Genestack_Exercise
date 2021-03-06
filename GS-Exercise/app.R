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
        selectizeInput("genes", "Find gene symbol:", 
                       choices = NULL),
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
            
            updateSelectizeInput(session, "genes", choices = df[df$go_term_label== input$inpt | substr(df$go_term_label, 1, nchar(input$inpt)) == input$inpt, "gene_symbol"],
                                 options = list(placeholder = 'start writing here...', create=FALSE), 
                                 selected = FALSE)
            
            h <- isolate(input$genes)
            
            if (h == ""){
                unique(paste0("<b>", "Associated gene: ", "</b>", 
                              "<p>", df[df$go_term_label== input$inpt | substr(df$go_term_label, 1, nchar(input$inpt)) == input$inpt, "gene_symbol"], "</p>", 
                              "<b>", " Synonyms: ", "</b>", 
                              "<p>", df[df$go_term_label== input$inpt | substr(df$go_term_label, 1, nchar(input$inpt)) == input$inpt, "gene_synonyms"],"</p>",
                              "<b>", " Ontology Term: ", "</b>", 
                              "<p>", df[df$go_term_label== input$inpt | substr(df$go_term_label, 1, nchar(input$inpt)) == input$inpt, "go_term_label"],"</p>", 
                              "<br>" ))
            }
            
            
            else {
                unique(paste0("<b>", "Associated gene: ", "</b>",
                              "<p>", df[df$go_term_label== h, "gene_symbol"], "</p>", 
                              "<b>", " Synonyms: ", "</b>", 
                              "<p>", df[df$go_term_label== h , "gene_synonyms"],"</p>",
                              "<b>", " Ontology Term: ", "</b>", 
                              "<p>", df[df$go_term_label== h, "go_term_label"],"</p>", 
                              "<br>" ))}
            
            
            
            
        }
        
    }) 
}

shinyApp(ui = ui, server = server)


