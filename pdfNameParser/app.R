library(shiny)
library(pdftools)
library(magrittr)
library(tidytext)
library(tibble)
library(dplyr)

fn_readPDFToDF <- function(pdf_url) {
  fname <- pdf_url %>% strsplit(.,"/") %>% .[[1]] %>% .[length(.)]
  download.file(pdf_url,fname,mode='wb')
  txt <- pdf_text(fname) %>% tibble::as_data_frame() %>%
    tibble::rowid_to_column("pageNumber")
  file.remove(fname)
  return(txt)
}

fn_extractNamesFromArxivText <- function(arxivDF) {
  names = arxivDF %>% unnest_tokens(output="twoGrams",input=value,token="ngrams",n=2,
                                    to_lower=FALSE) %>%
    mutate(nameMatch = str_extract(twoGrams,'[[:alpha:]]+\\s{1}[[:alpha:]]+\\d{1}')) %>%
    mutate(nameClean = str_replace(nameMatch,"\\d{1}","")) %>%
    filter(!is.na(nameMatch),pageNumber==1) %>%
    select(nameClean)
  return(names$nameClean %>% unique())
}

fn_arxivNameParser <- function(pdf_url) {
  return(pdf_url %>% fn_readPDFToDF(.) %>% fn_extractNamesFromArxivText(.))
}


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("PDF Article Author Extractor"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         textInput("url",
                     "Source PDF URL:")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         tableOutput("nameTable")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$nameTable <- renderTable(fn_arxivNameParser(input$url),
      striped=TRUE,bordered=TRUE
   )
}

# Run the application 
shinyApp(ui = ui, server = server)

