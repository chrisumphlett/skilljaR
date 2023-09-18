# skilljaR 0.1.2

* Created `get_user_domain()` which will return a data frame with requested user id and a column indicating if the user is in the domain.

# skilljaR 0.1.1

* Created `get_course_paths()` which will retrieve the list of paths and then the items (courses) associated with each path.

# skilljaR 0.1.0

* API endpoint for `get_users()` changed, to an endpoint that provides the `latest_activity` for each user. This is a significant improvement, enabling one to retrieve only updated course progress for users who have recent activity.
* This is a breaking change, as the `domains` argument is no longer required. This is an improvement -- now multiple API calls are not required.
* The users desired input is also not required anymore. By default the function will get all users. This argument would be used only to limit the of users (for testing purposes, for instance). The function will return all the pages, this argument isn't used to force it to get to enough pages either (and there is no risk of having redundant unnecessary calls).
* The `encoding_` arguments were removed for all functions, and `UTF-8` is being used by default.

# skilljaR 0.0.1

* The first version of the package.