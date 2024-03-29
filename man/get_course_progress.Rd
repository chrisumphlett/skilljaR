% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_course_progress.R
\name{get_course_progress}
\alias{get_course_progress}
\title{Get Course Progress for a List of Users}
\usage{
get_course_progress(user_ids, api_token)
}
\arguments{
\item{user_ids}{Vector of user id's for which you want course progress data}

\item{api_token}{Your personalized token provided by 'Skilljar'}
}
\value{
A data frame with users and user data
}
\description{
Returns a data.frame with all course progress details for a list of user
id's.
}
\details{
The API call only returns one user at a time. If you have many users then
it may take a long time for the function to return. You may also exceed the
'Skilljar' API rate limit.

Utilizing the API requires a token. This must be obtained by logging in
at dashboard.skilljar.com and going to Organization -> API Credentials.
There are different strategies for storing api tokens securely. It is 
an unnecessary risk to store the token in the script!
}
\examples{
\dontrun{
# Get some user id's
users <- get_users(domain = "training.mycompany.com",
users_desired = 10,
api_token = "my-token")

# Get course progress data
progress <- get_course_progress(user_ids = unique(users$user.id),
api_token = "my-token")
}
}
\seealso{
See \url{https://api.skilljar.com/docs/} for documentation on
the 'Skilljar' API.
}
