
pull_baseballr_gamepks <- function(levels, start_date, end_date) {
  start_date <- as.Date(start_date)
  end_date <- as.Date(end_date)
  dates <- seq.Date(start_date, end_date, by = "day")
  
  game_pks_all <- tibble::tibble(NULL)
  pb <- progress::progress_bar$new(total = length(dates))
  for(i in dates) {
    pb$tick()
    date_i <- as.Date(i, origin = as.Date("1970-01-01"))
    game_pks_i <- suppressMessages(baseballr::mlb_game_pks(date_i, level_ids = levels))
    if("data.frame" %in% class(game_pks_i)) {
      game_pks_all <- dplyr::bind_rows(game_pks_all, game_pks_i)
    }
  }
  
  result <- dplyr::filter(game_pks_all, 
                          status.detailedState %in% c("Final", "Completed Early"))
  result
}
