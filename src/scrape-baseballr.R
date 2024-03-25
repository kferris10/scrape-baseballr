
# notes ------------------------------------------------------------------------
# Author: Kevin Ferris
# Date: 2023-10-29
# takes 1-2 hours per level/season

# setup ------------------------------------------------------------------------

# R setup
options(stringsAsFactors = F, digits = 3, show.signif.stars = F, tidyverse.quiet = T)
set.seed(42)

# package setup
library(tidyverse)
library(baseballr)
library(progress)
library(here)
library(argparse)

# argument processing ----------------------------------------------------------

# manipulating file paths for local vs CLI runs
base_path <- here()
if(base_path == "/src") base_path <- ""
source(file.path(base_path, "src/helper-funs.R"))

# Define argument parser
params <- if(!interactive()) {
  parser <- ArgumentParser(description = "R script for processing scraped data")
  parser$add_argument("--action", type = "character", help = "the docker service running this script")
  parser$add_argument("--start_date", type = "character", help = "Start date (YYYY-MM-DD)")
  parser$add_argument("--end_date", type = "character", help = "End date (YYYY-MM-DD)")
  parser$add_argument("--level", type = "character", help = "see ?baseballr::mlb_game_pks")
  parser$parse_args()
} else {
  list(
    action = "scrape", 
    start_date = "2023-07-01", 
    end_date = "2023-07-03", 
    level = "lowa"
  )
}
print(params)

# cleaning params
params$start_date <- as.Date(params$start_date)
params$end_date <- as.Date(params$end_date)
level_num <- case_when(params$level == "mlb" ~ 1, 
                       params$level == "aaa" ~ 11, 
                       params$level == "aa" ~ 12, 
                       params$level == "higha" ~ 13, 
                       params$level == "lowa" ~ 14,  
                       params$level == "rookie" ~ 16, 
                       TRUE ~ NA_real_)


# path to save data
output_path <- file.path(base_path, "data/")
if(!dir.exists(output_path)) dir.create(output_path)
output_file <- paste0(
  "scraped_", 
  params$level, 
  "_", 
  params$start_date, 
  "_", 
  params$end_date, 
  ".RDS"
)

# process data -----------------------------------------------------------------

# 1-scrape data
print("Scraping data")
game_pks_scraped <- pull_baseballr_gamepks(level_num, params$start_date, params$end_date)
game_pks_clean <- game_pks_scraped |> 
  select(game_pk, gameType) |> 
  distinct()
df_scraped <- list_rbind(map(game_pks_clean$game_pk, mlb_pbp, .progress = T))

# saving -----------------------------------------------------------------------

print("Saving data")
saveRDS(df_scraped, file = file.path(output_path, output_file))





