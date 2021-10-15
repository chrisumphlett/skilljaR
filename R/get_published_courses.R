#' Get All Published Courses
#' 
#' Returns a data.frame with all published courses from a particular domain.
#' 
#' Utilizing the API requires a token. This must be obtained by logging in
#' at dashboard.skilljar.com and going to Organization -> API Credentials.
#' There are different strategies for storing api tokens securely. It is 
#' an unnecessary risk to store the token in the script!
#' 
#' @param domain Domain of 'Skilljar' account
#' @param api_token Your personalized token provided by 'Skilljar'
#' @param encoding_ API data encoding, do not use unless there is an error
#' 
#' @import httr
#' @importFrom purrr "is_empty"
#' @import jsonlite
#' @import dplyr
#' 
#' @return A data frame with all published course data
#' 
#' @seealso See \url{https://api.skilljar.com/docs/} for documentation on
#' the 'Skilljar' API.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' # Retrieve all published courses
#' courses <- get_published_courses(domain = "training.mycompany.com",
#' api_token = "my-token")
#' }

get_published_courses <- function(domain, api_token, encoding_ = "UTF-8"){

  token <- jsonlite::base64_enc(api_token)

  api_path <- paste0(
    "https://api.skilljar.com/v1/domains/",
    domain,
    "/published-courses")
  
  keep_going <- TRUE
  
  while (keep_going == TRUE) {
    get_results <- httr::GET(api_path,
                             httr::add_headers(
                               "Authorization" = paste(
                                 "Basic",
                                 gsub("\n", "", token)),
                               "Content-Type" = paste0(
                                 "application/x-www-form-urlencoded;charset=",
                                 encoding_)),
                             type = "basic"
    )
    get_text <- httr::content(get_results, "text", encoding = "UTF-8")
    get_json <- jsonlite::fromJSON(get_text, flatten = TRUE)
    courses_page <- as.data.frame(get_json$results)
    
    if (exists("all_published_courses")){
      all_published_courses <- dplyr::bind_rows(all_published_courses, courses_page)
    } else {
      all_published_courses <- courses_page
    }
    
    if (purrr::is_empty(unlist(get_json$`next`))){
      keep_going <- FALSE
    } else {
      api_path <- get_json$`next`
    }
  }
  return(all_published_courses)
}
