#' Get All Users
#' 
#' Returns a data.frame with all users from a particular domain. If you have 
#' many users and do not want to return them all at once, you may request
#' fewer users to save time while doing development. The API returns up 10,000
#' users at a time-- if you request more than 10,000, it will return in full
#' page increments (a multiple of 10,000).
#' 
#' Utilizing the API requires a token. This must be obtained by logging in
#' at dashboard.skilljar.com and going to Organization -> API Credentials.
#' There are different strategies for storing api tokens securely. It is 
#' an unnecessary risk to store the token in the script!
#' 
#' @param users_desired Number of user records to return
#' @param api_token Your personalized token provided by 'Skilljar'
#' 
#' @import httr
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
#' # Retrieve 1000 users
#' my_users <- get_users(users_desired = 1000,
#' api_token = "my-token")
#' }

get_users <- function(users_desired = 100000000, api_token){
  token <- jsonlite::base64_enc(api_token)
  
  get_pages <- httr::GET("https://api.skilljar.com/v1/users?page_size=1&page=1",
                         httr::add_headers(
                           "Authorization" = paste(
                             "Basic",
                             gsub("\n", "", token)),
                           "Content-Type" = paste0(
                             "application/x-www-form-urlencoded;charset=UTF-8"
                             )),
                         type = "basic"
  )
  get_text <- httr::content(get_pages, "text", encoding = "UTF-8")
  total_pages <- floor(
                  jsonlite::fromJSON(get_text, flatten = TRUE)$count / 10000
                  ) + 1
  pages_to_process <- min(total_pages, floor(users_desired / 10000) + 1)
  pages_list <- seq(from = 1, to = pages_to_process, by = 1)
  
  page_length <- min(users_desired, 10000)
  
  get_results <- function(x) {
    api_path <- paste0(
      "https://api.skilljar.com/v1/users?page_size=",
      page_length,
      "&page=",
      x)

    api_return <- httr::GET(api_path,
                           httr::add_headers(
                             "Authorization" = paste(
                               "Basic",
                               gsub("\n", "", token)),
                             "Content-Type" = paste0(
                               "application/x-www-form-urlencoded;charset=UTF-8"
                             )),
                           type = "basic"
                           )
    get_text <- httr::content(api_return, "text", encoding = "UTF-8")
    get_json <- jsonlite::fromJSON(get_text, flatten = TRUE)
    users_df <- as.data.frame(get_json$results)
    return(users_df)
  }
  
  df <- purrr::map_dfr(pages_list, get_results)
  
  return(df)

}
