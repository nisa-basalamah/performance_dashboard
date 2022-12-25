library(tidyverse)
library(googlesheets4)
library(googledrive)

options(
  # whenever there is one account token found, use the cached token
  gargle_oauth_email = TRUE,
  # specify auth tokens should be stored in a hidden directory ".secrets"
  gargle_oauth_cache = ".secrets"
)

sheet_id <- drive_get("performance")$id

# read files
sheet <- as.data.frame(read_sheet(ss = sheet_id))
model <- readRDS("model/rf_model.RDS")

# predict cluster_result
sheet$cluster_result <- predict(object = model,
                                newdata = sheet %>% select(-c(1,5)))

sheet_write(data = sheet,
            ss = sheet_id,
            sheet = "Sheet1")