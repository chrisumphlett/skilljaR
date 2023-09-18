#' Determine if User has joined a domain
#' 
#' Accepts a vector of user id's, and a domain, and returns a data.frame that
#' indicates if each id is found in that domain.
#' 
#' Utilizing the API requires a token. This must be obtained by logging in
#' at dashboard.skilljar.com and going to Organization -> API Credentials.
#' There are different strategies for storing api tokens securely. It is 
#' an unnecessary risk to store the token in the script!
#' 
#' @param user_ids Vector of user id's
#' @param domain Skilljar domain you want to search in
#' @param api_token Your personalized token provided by 'Skilljar'
#' 
#' @import httr
#' @importFrom purrr "map_dfr"
#' @import jsonlite
#' 
#' @return A data.frame that indicates if each id is found in that domain.
#' 
#' @seealso See \url{https://api.skilljar.com/docs/} for documentation on
#' the 'Skilljar' API.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' # Retrieve user data and domain for 100 users
#' my_users <- get_users(users_desired = 100,
#' api_token = "my-token")
#' user_vector <- users %>% select(user_id) %>% pull()
#' my_users2 <- get_user_domain(user_vector, "my-domain.skilljar.com",
#' api_token = "my-token")
#' }

get_user_domain <- function(#users_desired = 100000000, 
  domain, user_ids, api_token){
  token <- jsonlite::base64_enc(api_token)
  
  get_user_domains <- function(.u){
    results <- httr::GET(paste0("https://api.skilljar.com/v1/domains/",
                                domain,
                                "/users/",
                                .u),
                                #?page_size=1&page=1",
                         httr::add_headers(
                           "Authorization" = paste(
                             "Basic",
                             gsub("\n", "", token)),
                           "Content-Type" = paste0(
                             "application/x-www-form-urlencoded;charset=UTF-8"
                           )),
                         type = "basic"
    )
    get_text <- httr::content(results, "text", encoding = "UTF-8")
    if (get_text == "{\"detail\":\"Not found.\"}"){
      in_domain <- FALSE
    } else {
      in_domain <- TRUE
    }
    df <- tibble(user_id = .u, in_domain = in_domain)
  }
  
  df <- purrr::map_dfr(user_ids, get_user_domains)
  return(df)
  
}
