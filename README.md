# GitHub Actions Accelerator

Used to push up my development environment and access key secrets to be auto-created in new Github Repos so they can be used by GitHub actions.


## Prerequisites

Before using this script, ensure that you have the following:

1. A GitHub personal access token with appropriate permissions to create repositories. You can create a token by following the instructions [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).
2. The `GIT_TOKEN` environment variable must be set with your GitHub personal access token.

## Installation

To use this script, you need to have the following software installed:


1. `curl`: Command-line tool for making HTTP requests. It is usually pre-installed on most Unix-based systems.
2. `git`: Version control system for managing repositories. Install it by following the instructions for your operating system.


### Initializing a Local Repository

1. In the terminal, navigate to the directory where you want to initialize the local repository.
2. Run the following command to initialize the repository: `git init`.
3. Add and commit the first local commit using the necessary `git add` and `git commit` commands.


## Usage

1. Clone this repository or copy the shell script to your local machine.
2. Open a terminal and navigate to the directory containing the script.
3. Make the script executable if needed: `chmod +x createNewRepo.sh`.
4. Run the script, providing the desired repository name as an argument: `./create-repo.sh <repository-name>`.
5. The script will create the repository and print the owner/repo name and the HTTPS format remote URL.

## Example

To create a new repository named `my-new-repo`, run the following command:

```bash
./createNewRepo.sh my-new-repo
```

### Adding Remote Origin and Pushing the First Commit

1. In the terminal, navigate to the local repository directory.
2. Run the following command to add the remote origin: `git remote add origin <repository-url>`, replacing `<repository-url>` with the captured `Repo URL` from running the script.
3. Push the first commit to the remote origin using the following command: `git push -u origin master`.



*Usage*:


https://docs.github.com/en/actions/security-guides/encrypted-secrets


## Create the Repo


https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#create-a-repository-for-the-authenticated-user

```
#!/bin/bash

REPO_NAME=$1
TOKEN=$GIT_TOKEN
OWNER="<YOUR-USERNAME>"

URL="https://api.github.com/user/repos"

response=$(curl -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d "{\"name\":\"${REPO_NAME}\"}" \
  "${URL}")

OWNER_REPONAME=$(echo "$response" | jq -r '.full_name')

echo "Owner/Repo Name: $OWNER_REPONAME"
```


## Get the new REPO's public key

https://docs.github.com/en/rest/actions/secrets?apiVersion=2022-11-28#get-a-repository-public-key

'OWNER' = Repo Org / Owne
'REPO' = new Repo name

```
#!/bin/bash

OWNER_REPONAME=$1  # First argument: OWNER_REPONAME
TOKEN=$GIT_TOKEN

URL="https://api.github.com/repos/${OWNER_REPONAME}/actions/secrets/public-key"

response=$(curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "${URL}")

KEY=$(echo "$response" | jq -r '.key')
KEY_ID=$(echo "$response" | jq -r '.keyid')

echo "Owner/Repo Name: ${OWNER_REPONAME}"
echo "Key: ${KEY}"
echo "Key ID: ${KEY_ID}"
```

## Encrypt the local tokens into the Repo secrets using the Keys


#!/bin/bash

# Define the secret names
SECRET_NAME_1="GIT_USER_NAME"
SECRET_NAME_2="DOCKER_USERNAME"

# Retrieve the secret values from environment variables
SECRET_VALUE_1="${GIT_USER_NAME}"
SECRET_VALUE_2="${DOCKER_USERNAME}"

# Function to encrypt a secret using Node.js script
encryptSecret() {
  local key=$1
  local secret=$2

  # Invoke the Node.js script and pass the key and secret as command line arguments
  encryptedSecret=$(node createSecret.js "$key" "$secret")
  echo "$encryptedSecret"
}

# Encrypt secrets
ENCRYPTED_SECRET_1=$(encryptSecret "encryption-key-1" "$SECRET_VALUE_1")
ENCRYPTED_SECRET_2=$(encryptSecret "encryption-key-2" "$SECRET_VALUE_2")

# GitHub API endpoint for creating repository secrets
OWNER_REPO="owner/examplerepo"  # Replace with your repository path
API_URL="https://api.github.com/repos/$OWNER_REPO/actions/secrets"

# Function to create a repository secret using curl
createSecret() {
  local name=$1
  local value=$2

  curl -X PUT \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: Bearer $GIT_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"encrypted_value\":\"$value\",\"key_id\":\"public-key-id\"}" \
    "$API_URL/$name"
}

# Create repository secrets
createSecret "$SECRET_NAME_1" "$ENCRYPTED_SECRET_1"
createSecret "$SECRET_NAME_2" "$ENCRYPTED_SECRET_2"



