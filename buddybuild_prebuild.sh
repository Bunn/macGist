#!/usr/bin/env bash


FILE="macGist/Credentials.plist"

/usr/libexec/PlistBuddy -c "set :GitHubClientID ${GitHubClientID}" ${FILE}
/usr/libexec/PlistBuddy -c "set :GitHubSecret ${GitHubClientSecret}" ${FILE}
