# skilljaR
Connect To Your Skilljar Data With R

## Installation
Install the development version with `devtools::install_github("chrisumphlett/skilljaR")`.

## Functionality
* Currently only one function, `get_users`. It returns a data.frame with all users from a particular domain. The API only returns up to 10,000 users at a time. The function makes multiple requests to the API in order to return the desired number of users. The user needs to know, or guess, how many users they have if they want to return them all. You can select an arbitrarily large number to be safe but it will result in a longer execution time as there will be unnecessary API requests sent.

## Security
Utilizing the API requires a token. This must be obtained by logging in
at dashboard.skilljar.com and going to Organization / API Credentials.
There are different strategies for storing api tokens securely. This package
does not require nor nudge you towards any one strategy. That said, it is 
an unnecessary risk to store the token in the script!