# Render any materials / analysis relying on non-interactive access to 
# Google Sheets

# Quick start

# Make sure to set appropriate secrets to allow auto-rendering to happen.
# This can be done via settings > secrets > actions menus.
# Key should be generated in json format via the https://console.cloud.google.com/
# interface, by creating a key that can be used by a Google Service Account.

# Note that credentials need to be passed in the workflows first. Any
# Google Sheets in question must also be shared with the Google Service Account.

# See https://www.avahoffman.com/GHA_and_googlesheets/ for the full guide

install.packages("jsonlite", repos = "https://cloud.r-project.org")

library(optparse) # make_option OptionParser parse_args
library(jsonlite) # fromJSON

# --------- Get the output from GHA ---------

# Look for the data_in argument
option_list <- list(
  optparse::make_option(
    c("--data_in"),
    type = "character",
    default = NULL,
    help = "Sheet Results (json)",
  )
)

# Read the results provided as command line argument
opt_parser <- optparse::OptionParser(option_list = option_list)
opt <- optparse::parse_args(opt_parser)
jsonResults <- opt$data_in

# --------- Interpret the JSON data ---------

# Pull the data itself from the API results
df <- fromJSON(jsonResults)
df <- df$results$result$formatted[[2]]

# Repair if you have column names on your spreadsheet
colnames(df) <- df[1, ] # colnames taken from first row of data
df <- df[-1, ] # remove the first row of data (original column names)
df <- tibble::as_tibble(df)

# --------- Any analysis you want to do ---------
# --------- Don't print sensitive data!! --------

df$`How would you rate our platform?` <- as.numeric(df$`How would you rate our platform?`)
print(mean(df$`How would you rate our platform?`))

# --------- Render web pages from Rmd docs ---------

rmarkdown::render_site(
  input = "pages",
  envir = new.env(parent = globalenv()) # enable use of 'df' inside the Rmd being rendered
) 
