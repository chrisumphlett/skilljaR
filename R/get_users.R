#' Get All Users From Skilljar API
#' 
#' Returns a data.frame with all users from a particular domain. The API
#' only returns up to 10,000 users at a time. The function makes multiple
#' requests to the API in order to return the desired number of users.
#' The user needs to know, or guess, how many users they have if they want
#' to return them all. You can select an arbitrarily large number to be 
#' safe but it will result in a longer execution time as there will be 
#' unnecessary API requests sent.
#' 
#' Utilizing the API requires a token. This must be obtained by logging in
#' at dashboard.skilljar.com and going to Organization -> API Credentials.
#' There are different strategies for storing api tokens securely. It is 
#' an unnecessary risk to store the token in the script!
#' 
#' @param domain Domain of Skilljar account
#' @param users_desired Number of user records to return
#' @param api_token Your personalized token provided by Skilljar
#' @param encoding_ API data encoding, do not use unless there is an error
#' 
#' @import httr
#' @import jsonlite
#' @importFrom purrr "map_dfr"
#' 
#' @return A data frame with users and user data
#' 
#' @seealso See \url{https://api.skilljar.com/docs/} for documentation on
#' the Skilljar API.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' # Retrieve 1000 users
#' my_users <- get_users(domain = "training.mycompany.com",
#' users_desired = 1000,
#' api_token = "my-token")
#' }
users_desired <- 1000
api_token <- "sk-live-ab5169ba652601a3c27eaee28cbacd9f052876cb"
domain <- "academy.techsmith.com"
get_users <- function(domain, users_desired, api_token, encoding_ = "UTF-8"){
  total_pages <- floor(users_desired / 10000) + 1
  pages_list <- seq(from = 1, to = total_pages, by = 1)
  
  token <- jsonlite::base64_enc(api_token)
  
  get_results <- function(x) {
    build_api_path <- paste0("https://api.skilljar.com/v1/domains/",
           domain,
           "/users?page_size=10000&page=",
           x)
    get_results <- httr::GET(build_api_path, httr::add_headers(
      "Authorization" = paste("Basic", gsub("\n", "", token)),
      "Content-Type" = "application/x-www-form-urlencoded;charset=UTF-8"
    ), type = "basic")
    get_text <- httr::content(get_results, "text", encoding = "UTF-8")
    get_json <- jsonlite::fromJSON(get_text, flatten = TRUE)
    iteration_df <- as.data.frame(get_json$results)
    return(iteration_df)
  }
  
  df <- purrr::map_dfr(pages_list, get_results)
  
  return(df)

}
