# pdfAuthorNameParser
web app that extracts author names from a pdf from sources like arXiv

## Dependencies
The main application is an R Shiny web app, which relies on having R 3.4+ and the following R packages installed in your local environment:
* shiny
* pdftools
* magrittr
* tidytext
* tibble
* dplyr

You can run the app in your browser by downloading the project, navigating to it in your terminal, and typing:
```bash
R -e "shiny::runApp('~/pdfNameParser')"
```
