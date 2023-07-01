#!/bin/bash

OWNER_REPO=$1  # First argument: OWNER_REPO
TOKEN=$GIT_TOKEN # Env variable for GH Token

# Define the secret names
SECRET_NAME_1="GIT_USER_NAME"
SECRET_NAME_2="DOCKER_USERNAME"
SECRET_NAME_3="DOCKER_PASSWORD"
SECRET_NAME_4="AWS_ACCESS_KEY_ID"
SECRET_NAME_5="AWS_SECRET_ACCESS_KEY"
SECRET_NAME_6="AWS_DEFAULT_REGION"
SECRET_NAME_7="GIT_TOKEN"
SECRET_NAME_8="GIT_USER_EMAIL"

# Retrieve the secret values from environment variables
SECRET_VALUE_1="${GIT_USER_NAME}"
SECRET_VALUE_2="${DOCKER_USERNAME}"
SECRET_VALUE_3="${DOCKER_PASSWORD}"
SECRET_VALUE_4="${AWS_ACCESS_KEY_ID}"
SECRET_VALUE_5="${AWS_SECRET_ACCESS_KEY}"
SECRET_VALUE_6="${AWS_DEFAULT_REGION}"
SECRET_VALUE_7="${GIT_TOKEN}"
SECRET_VALUE_8="${GIT_USER_EMAIL}"

# Function to get the Repo Public Key
getKeyIds() {
  URL="https://api.github.com/repos/${OWNER_REPO}/actions/secrets/public-key"
  echo "Trying URL: ${URL}"

  response=$(curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "${URL}")

  echo "Response: $response"

  KEY=$(echo "$response" | jq -r '.key')
  KEY_ID=$(echo "$response" | jq -r '.key_id')

  echo "Owner/Repo Name: ${OWNER_REPO}"
  echo "Key: ${KEY}"
  echo "Key ID: ${KEY_ID}"
}

# Encrypt secrets
encryptSecret() {
  local key=$1
  local secret=$2

  encryptedSecret=$(node createSecret.js "$key" "$secret")
  echo "$encryptedSecret"
}

# Set the KeyID's
getKeyIds

# GitHub API endpoint for creating repository secrets
API_URL="https://api.github.com/repos/${OWNER_REPO}/actions/secrets"

# Function to create a repository secret using curl
createSecret() {
  local name=$1
  local value=$2

  response=$(curl -s -o /dev/null -w "%{http_code}" -X PUT \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"encrypted_value\":\"$value\",\"key_id\":\"$KEY_ID\"}" \
    "$API_URL/$name")

  if [ $response -eq 201 ]; then
    echo "Successfully created secret '$name' with Key ID: '$KEY_ID' and URL: $API_URL/$name"
  else
    echo "Failed to create secret '$name'"
  fi
}

# Create repository secrets
ENCRYPTED_SECRET_1=$(encryptSecret "$KEY" "$SECRET_VALUE_1")
createSecret "$SECRET_NAME_1" "$ENCRYPTED_SECRET_1"

ENCRYPTED_SECRET_2=$(encryptSecret "$KEY" "$SECRET_VALUE_2")
createSecret "$SECRET_NAME_2" "$ENCRYPTED_SECRET_2"

ENCRYPTED_SECRET_3=$(encryptSecret "$KEY" "$SECRET_VALUE_3")
createSecret "$SECRET_NAME_3" "$ENCRYPTED_SECRET_3"

ENCRYPTED_SECRET_4=$(encryptSecret "$KEY" "$SECRET_VALUE_4")
createSecret "$SECRET_NAME_4" "$ENCRYPTED_SECRET_4"

ENCRYPTED_SECRET_5=$(encryptSecret "$KEY" "$SECRET_VALUE_5")
createSecret "$SECRET_NAME_5" "$ENCRYPTED_SECRET_5"

ENCRYPTED_SECRET_6=$(encryptSecret "$KEY" "$SECRET_VALUE_6")
createSecret "$SECRET_NAME_6" "$ENCRYPTED_SECRET_6"

ENCRYPTED_SECRET_7=$(encryptSecret "$KEY" "$SECRET_VALUE_7")
createSecret "$SECRET_NAME_7" "$ENCRYPTED_SECRET_7"

ENCRYPTED_SECRET_8=$(encryptSecret "$KEY" "$SECRET_VALUE_8")
createSecret "$SECRET_NAME_8" "$ENCRYPTED_SECRET_8"
