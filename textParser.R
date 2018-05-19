library(pdftools)
library(magrittr)
library(tidytext)
library(tidyverse)

pdf_url <- "https://arxiv.org/pdf/1512.02325.pdf"

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

############# backup code #############
names <- txt %>% unnest_tokens(output="twoGrams",input=value,token="ngrams",n=2,
                                   to_lower=FALSE) %>%
  mutate(nameMatch = str_extract(twoGrams,'[[:alpha:]]+\\s{1}[[:alpha:]]+\\d{1}')) %>%
  mutate(nameClean = str_replace(nameMatch,"\\d{1}","")) %>%
  filter(!is.na(nameMatch),pageNumber==1) %>%
  select(nameClean)

two_grams$nameMatch <- sapply(two_grams$two_grams,function(x) {grep('[[:alpha:]]+\\s{1}[[:alpha:]]+\\d{1}',x,value=TRUE)[1]})

# name_pattern <- '(\w+\s\w+)'

# matches <- grep('(\\w+\\s{1}\\w+)',txt,value = TRUE)
# matches <- grep('[[:alpha:]]+\\s{1}[[:alpha:]]+\\d{1}',strsplit(txt[1],",")[[1]],value = TRUE)
