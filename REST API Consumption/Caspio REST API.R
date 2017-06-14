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

# Create your own application key at https://YOUR_SITE.caspio.com/ui/access
client_key     = "PROFILE_CLIENT_KEY";
client_secret  = "PROFILE_CLIENT_SECRET";

# Caspio OAuth endpoints
caspio_url        = "https://YOUR_SITE.caspio.com/";
token_endpoint    = paste(caspio_url, "oauth/token", sep = "");
resource_endpoint = paste(caspio_url, "rest/v1/", sep = "");

# Use basic auth
secret  <- openssl::base64_encode(paste(client_key, client_secret, sep = ":"));
request <- httr::POST(token_endpoint,
  httr::add_headers(
    "Authorization" = paste("Basic", secret),
    "Content-Type" = "application/x-www-form-urlencoded;charset=UTF-8"
  ),
  body = "grant_type=client_credentials",
  encode = "json"
);

# Use basic auth
secret  <- openssl::base64_encode(paste(client_key, client_secret, sep = ":"));
request <- httr::POST(token_endpoint,
  httr::add_headers(
    "Authorization" = paste("Basic", secret)
  ),
  body   = "grant_type=client_credentials",
  encode = "json"
);

# Extract the access token
token <- paste("Bearer", content(request)$access_token)

# Actual API call
url     <- paste(resource_endpoint, "tables", sep = "");
request <- httr::GET(url, add_headers(Authorization = token))
json    <- httr::content(request, as = "text")
tables  <- fromJSON(json)

# Display the Caspio tables
print(tables)
