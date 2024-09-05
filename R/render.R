# Render any materials relying on googlesheets4 package

# Make sure to set appropriate secrets to allow auto-rendering to happen. 
# This can be done via settings > secrets > actions menus.
# Key should be generated in json format via the https://console.cloud.google.com/
# interface, by creating a key that can be used by a Google Service Account.

# Note that credentials need to be created in the workflows first. Any 
# Google Sheets in question must also be shared with the Google Service Account.


install.packages(c("optparse", "jsonlite", "dplyr"),
                 repos = "https://cloud.r-project.org")
library(optparse)
library(jsonlite)
library(dplyr)

# --------- Get the GHA output ---------

# Look for the data_in argument
option_list <- list(
  optparse::make_option(
    c("--data_in"),
    type = "character",
    default = NULL,
    help = "Sheet Results (json)",
  )
)

# Read the resutlts provided as command line argument
opt_parser <- optparse::OptionParser(option_list = option_list)
opt <- optparse::parse_args(opt_parser)
jsonResults <- opt$data_in

# --------- Interpret the JSON data ---------

df <- fromJSON(jsonResults)
df <- out2$results$result$formatted[[2]]

# Repair if you have column names on your spreadsheet
colnames(df) <- df[1,] # colnames taken from first row of data
df <- df[-1,] # remove the first row of data (original column names)

# --------- Any analysis you want to do ---------

message(df)