#!/bin/bash

REPO_NAME=$1
TOKEN=$GIT_TOKEN
OWNER="npiper"

URL="https://api.github.com/user/repos"

response=$(curl -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d "{\"name\":\"${REPO_NAME}\"}" \
  "${URL}")

OWNER_REPONAME=$(echo "$response" | jq -r '.full_name')
REPO_URL=$(echo "$response" | jq -r '.html_url')

echo "Owner/Repo Name: $OWNER_REPONAME"
echo "Repo URL: $REPO_URL"
