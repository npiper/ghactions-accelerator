#!/bin/bash

OWNER_REPONAME=$1  # First argument: OWNER_REPONAME
TOKEN=$GIT_TOKEN

URL="https://api.github.com/repos/${OWNER_REPONAME}/actions/secrets/public-key"

echo "Trying URL: ${URL}"

response=$(curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "${URL}")

echo "Response: $response"

KEY=$(echo "$response" | jq -r '.key')
KEY_ID=$(echo "$response" | jq -r '.key_id')

echo "Owner/Repo Name: ${OWNER_REPONAME}"
echo "Key: ${KEY}"
echo "Key ID: ${KEY_ID}"
