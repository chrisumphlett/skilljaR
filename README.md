# skilljaR

`skilljaR` is an R wrapper for the Skilljar API.

## Installation

Install from CRAN with `install.packages("skilljaR").`

Install the development version with `devtools::install_github("chrisumphlett/skilljaR")`.

## Functionality

* `get_users()` returns a data.frame with all users from a particular domain. The API only returns up to 10,000 users at a time. The function makes multiple requests to the API in order to return the desired number of users. The user needs to know, or guess, how many users they have if they want to return them all. You can select an arbitrarily large number to be safe but it will result in a longer execution time as there will be unnecessary API requests sent.
* `get_published_courses()` returns a data.frame with all published courses in a particular domain.
* `get_course_progress()` returns a data.frame with the course progress progress for user enrollments in your courses. You must supply a vector of user id's (which can be generated from the results of `get_users()`).

The motivation for this package was to replicate, and improve upon, the manual enrollments data export in the Skilljar portal. The results of `get_course_progress()` joined back together with the results of `get_users()` should reproduce that export but with additional fields. Some of the columns are named differently.

## Security
Utilizing the API requires a token. This must be obtained by logging in at dashboard.skilljar.com and going to Organization / API Credentials. There are different strategies for storing api tokens securely. This package does not require nor nudge you towards any one strategy. That said, it is an unnecessary risk to store the token in the script!