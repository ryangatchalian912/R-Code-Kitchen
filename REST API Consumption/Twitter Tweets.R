# TODO:
#     Install these packages first via
#     install.packages("package-name")
#     if they aren't yet installed

# Import required packages
if (!require(jsonlite))
{
  install.packages("jsonlite")
  library(jsonlite)
}

if (!require(xml2))
{
  install.packages("xml2")
  library(xml2)
}

if (!require(openssl))
{
  install.packages("openssl")
  library(openssl)
}

if (!require(httr))
{
  install.packages("httr")
  library(httr)
}

if (!require(ggplot2))
{
  install.packages("ggplot2")
  library(ggplot2)
}

# Create your own application key at https://dev.twitter.com/apps
consumer_key    = "CONSUMER_KEY"
consumer_secret = "CONSUMER_SECRET"

# Twitter OAuth endpoints
twitter_url       = "https://api.twitter.com/"
token_endpoint    = paste(twitter_url, "oauth2/token", sep = "")
resource_endpoint = paste(twitter_url, "1.1/", sep = "")

# Use basic auth
secret  <- openssl::base64_encode(paste(consumer_key, consumer_secret, sep = ":"))
request <- httr::POST(token_endpoint,
  httr::add_headers(
    "Authorization" = paste("Basic", secret),
    "Content-Type" = "application/x-www-form-urlencoded;charset=UTF-8"
  ),
  body = "grant_type=client_credentials"
);

# Extract the access token
token <- paste("Bearer", content(request)$access_token)

# Actual API call
url     <- paste(resource_endpoint, "statuses/user_timeline.json?count=10&screen_name=Rbloggers", sep = "")
request <- httr::GET(url, add_headers(Authorization = token))
json    <- httr::content(request, as = "text")
tweets  <- fromJSON(json)

# Display the tweets
print(substring(tweets$text, 1, 100))
