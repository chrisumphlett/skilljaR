#' Get Course Paths
#' 
#' Returns a data.frame with all paths and the items in those paths.
#' 
#' Utilizing the API requires a token. This must be obtained by logging in
#' at dashboard.skilljar.com and going to Organization -> API Credentials.
#' There are different strategies for storing api tokens securely. It is 
#' an unnecessary risk to store the token in the script!
#' 
#' @param api_token Your personalized token provided by 'Skilljar'
#' 
#' @import httr
#' @import dplyr
#' @importFrom magrittr "%>%"
#' @importFrom purrr "map_dfr"
#' @import jsonlite
#' 
#' @return A data frame with users and user data
#' 
#' @seealso See \url{https://api.skilljar.com/docs/} for documentation on
#' the 'Skilljar' API.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' # Get course progress data
#' paths <- get_course_paths(api_token = "my-token")
#' }

get_course_paths <- function(api_token){
  
  token <- jsonlite::base64_enc(api_token)
  
  # get the paths first
  api_path <- paste0("https://api.skilljar.com/v1/paths")
  get_results <- httr::GET(api_path, httr::add_headers(
    "Authorization" = paste("Basic", gsub("\n", "", token)),
    "Content-Type" = "application/x-www-form-urlencoded;charset=UTF-8"
  ), type = "basic")
  paths_df <- as.data.frame(
    jsonlite::fromJSON(
      httr::content(get_results, "text", encoding = "UTF-8"),
      flatten = TRUE
      )$results
    ) %>%
    rename(path_id = .data$id, path_name = .data$title)
  
  # list of path id's in a vector to pass into next call
  path_ids <- pull(paths_df, .data$path_id)

  map_across_paths <- function(.x){
    
    api_path <- paste0("https://api.skilljar.com/v1/paths/",
                       .x,
                       "/path-items")
    
    get_results <- httr::GET(api_path,
                             httr::add_headers(
                               "Authorization" = paste(
                                 "Basic",
                                 gsub("\n", "", token)),
                               "Content-Type" = paste0(
                                 "application/x-www-form-urlencoded;charset=UTF-8")),
                             type = "basic"
    )
    items_df <- as.data.frame(
      jsonlite::fromJSON(
        httr::content(get_results, "text", encoding = "UTF-8"),
        flatten = TRUE
        )$results
      ) %>%
      dplyr::mutate(path_id = .x)
  }
  all_path_items <- purrr::map_dfr(path_ids, map_across_paths) %>%
    dplyr::left_join(paths_df)
}
