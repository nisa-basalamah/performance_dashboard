# load library
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)
# library(fmsb)
# library(ggiraphExtra)
library(ggradar)
library(calendR)
library(tidyverse)
library(reshape)
library(glue)
library(padr)
library(lubridate)
library(caret)
library(randomForest)
library(rintrojs)
library(googlesheets4)
library(googledrive)

options(
  # whenever there is one account token found, use the cached token
  gargle_oauth_email = TRUE,
  # specify auth tokens should be stored in a hidden directory ".secrets"
  gargle_oauth_cache = ".secrets"
)

# Get the ID of the sheet for writing programmatically
# This should be placed at the top of your shiny app
sheet_id <- drive_get("performance")$id

# read file
model <- readRDS("model/rf_model.RDS") # model
