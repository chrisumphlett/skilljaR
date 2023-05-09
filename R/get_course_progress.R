#' Get Course Progress for a List of Users
#' 
#' Returns a data.frame with all course progress details for a list of user
#' id's. 
#' 
#' The API call only returns one user at a time. If you have many users then
#' it may take a long time for the function to return. You may also exceed the
#' 'Skilljar' API rate limit.
#' 
#' Utilizing the API requires a token. This must be obtained by logging in
#' at dashboard.skilljar.com and going to Organization -> API Credentials.
#' There are different strategies for storing api tokens securely. It is 
#' an unnecessary risk to store the token in the script!
#' 
#' @param user_ids Vector of user id's for which you want course progress data
#' @param api_token Your personalized token provided by 'Skilljar'
#' 
#' @import httr
#' @import dplyr
#' @importFrom magrittr "%>%"
#' @importFrom purrr "is_empty"
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
#' # Get some user id's
#' users <- get_users(domain = "training.mycompany.com",
#' users_desired = 10,
#' api_token = "my-token")
#' 
#' # Get course progress data
#' progress <- get_course_progress(user_ids = unique(users$user.id),
#' api_token = "my-token")
#' }

get_course_progress <- function(user_ids, api_token){
  
  token <- jsonlite::base64_enc(api_token)
  # i <- 1
  map_across_users <- function(.x){

    api_path <- paste0("https://api.skilljar.com/v1/users/",
                       .x,
                       "/published-courses")
    
    get_results <- httr::GET(api_path,
                       httr::add_headers(
                         "Authorization" = paste(
                           "Basic",
                           gsub("\n", "", token)),
                         "Content-Type" = paste0(
                           "application/x-www-form-urlencoded;charset=UTF-8")),
                       type = "basic"
    )
    get_text <- httr::content(get_results, "text", encoding = "UTF-8")
    
    ## skip this if there were no results for the user
    if(get_text != "[]"){
      user_progress <- as.data.frame(jsonlite::fromJSON(get_text,
                                                        flatten = TRUE)) %>%
        mutate(user_id = .x) %>%
        select(-.data$all_enrollments)
    }
    # i <- 1 + 1

  }
  all_progress <- purrr::map_dfr(user_ids, map_across_users)
}
