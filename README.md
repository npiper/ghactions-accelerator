# GitHub Actions Accelerator

Convenience scripts from command line to create new Repos and  push up my development environment 
and access key secrets to be auto-created in new Github Repos so they can be used by GitHub actions.


## Prerequisites

Before using this script, ensure that you have the following:

1. A GitHub personal access token with appropriate permissions to create repositories. You can create a token by following the instructions [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).
2. The `GIT_TOKEN` environment variable must be set with your GitHub personal access token.

## Installation

To use this script, you need to have the following software installed:


1. `curl`: Command-line tool for making HTTP requests. It is usually pre-installed on most Unix-based systems.
2. `git`: Version control system for managing repositories. Install it by following the instructions for your operating system.
3. `npm` and Node.js: Ensure that you have Node.js installed on your machine. You can download it from [https://nodejs.org](https://nodejs.org) and follow the installation instructions specific to your operating system.


## Prerequisite: Compiling the node `createSecret.js` Script

Before being able to script writing of repository secrets, you need to setup the node environment for the `createSecret.js` script. This is later used to encrypt the secret values using a public key from the created Github Repo. 

This script uses the `libsodium` library for encryption. Follow the steps below to compile the script:

### Steps to Run the Script

1. Check out the repository to your local machine using Git:

   ```bash
   git clone https://github.com/npiper/npm-sodium.git
   ```

2. Navigate to the repository's root directory:

   ```bash
   cd npm-sodium
   ```

3. Install the required dependencies by running the following command:

   ```bash
   npm install
   ```

> Note: The `createSecret.js` script uses the `libsodium` library for encryption, which ensures secure encryption of secrets. The encryption process is handled within the script, and the encrypted values will be used when setting up repository secrets.


![Creation](http://www.plantuml.com/plantuml/svg/TP5HQzim483VzIkkeG_hWssonp9AJQ9b9cbIB8So61Z5lYG2MnBIUMMK_FT5gPSqNM9iRDttdUwiU_Ga7NLjmsvgN2kD89xphE1YcSzWIsJzVP8u-Hfl56sxLUVHLKOJQeehqoQsaJfaHvxgHgsIZMfMqkrl6PsGTOhG9x-7yJ3f5-n6wQhfQknSyw5YybubaXKfetriGsEC53K8GhPs_yhH6g_8k3ym-G7fGGI1bKFoZ3ciIEhDtXjykptVxE6NdXm2VP8VWFImsVOhU6ECGRZMfgdHmK1RPT4bjsyEhTaTxF0Ln3ElBpuu0kb8hML5CCcASYbuNixJ9_w9ZHUZwPu4V9q-fqAyBFBn9vg-Y38TZRWGvPJ_BBDBNF1HpeiFsWLdpB-dorbHvdoIBUONcYyMKpw_zbFyASrc0UvOU7QCiSgqrcZK19L3IJZ7rp2ls6z1-bFiFoz8_J6UkSUv7bCXYXxUnt0FNuPtlNU8iBES89vc4-olTv3MDVX_Ux97r7NNDdy1)

## Initializing a Local Repository

1. In the terminal, navigate to the directory where you want to initialize the local repository.
2. Run the following command to initialize the repository: `git init`.
3. Add and commit the first local commit using the necessary `git add` and `git commit` commands.


### Usage to create a new Github Repo

1. Clone this repository or copy the shell script to your local machine.
2. Open a terminal and navigate to the directory containing the script.
3. Make the script executable if needed: `chmod +x createNewRepo.sh`.
4. Run the script, providing the desired repository name as an argument: `./create-repo.sh <repository-name>`.
5. The script will create the repository and print the owner/repo name and the HTTPS format remote URL.

### Example

To create a new repository named `my-new-repo`, run the following command:

```bash
./createNewRepo.sh my-new-repo
```

### Adding Remote Origin and Pushing the First Commit

1. In the terminal, navigate to the local repository directory.
2. Run the following command to add the remote origin: `git remote add origin <repository-url>`, replacing `<repository-url>` with the captured `Repo URL` from running the script.
3. Push the first commit to the remote origin using the following command: `git push -u origin master`.


## Creating Repository Secrets

Once your remote Repo is created, in order to create repository secrets for your newly created repository, you can use the provided shell script `createRepoSecrets.sh`. This script encrypts and sets the necessary secrets in your repository for use in workflows. Follow the steps below:

### Prerequisites

Before creating repository secrets, make sure you have completed the following prerequisites:

1. Ensure that you have executed the earlier `createNewRepo.sh` script successfully and have obtained the owner/repo name and the HTTPS format remote URL.
2. That you have a local environment variable with a GitHub Token value set that can add Repository secrets in the varaible `GIT_TOKEN`
3. An nodeJS envrionment that has been created so that the dependent encryption script `createSecret.js` can be executed by the Script
4. Set up the necessary environment variables required for creating secrets. These environment variables should contain the values you want to set as secrets. Make sure the values are accessible within your local environment.

### Steps to Create Repository Secrets

1. Open a terminal and navigate to the directory containing the `createRepoSecrets.sh` script.
2. Make the script executable if needed: `chmod +x createRepoSecrets.sh`.
3. Run the script, providing the owner/repo name as an argument: `./createRepoSecrets.sh <owner>/<repo>`.
4. The script will attempt to retrieve the repository's public key using the GitHub API.
5. The script will encrypt the secret values provided in the script using the public key.
6. Encrypted secrets will be created and set in the repository using the GitHub API.

> Note: The provided script assumes you have a `createSecret.js` script or function that handles the encryption process. Make sure to have this script or function in the same directory as `createRepoSecrets.sh` for successful execution.

Once the script completes successfully, the repository secrets will be available for use in your workflows.

## Example

To create repository secrets for the repository `npiper/my-new-repo`, run the following command:

```bash
./createRepoSecrets.sh npiper/my-new-repo
```

## Forking for your own use

This should be usable for your personal repos if you just replace the value `npiper` with your own personal user in these scripts.

Need to create a Github token that has permissions to create / read repos and add secrets.

These are the local environment variables I have behind the defaults;

```
' GIT User Name
GIT_USER_NAME

'DockerHub User/Pass
DOCKER_USERNAME
DOCKER_PASSWORD

'AWS Signin details

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION
```

## References



https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#create-a-repository-for-the-authenticated-user

https://docs.github.com/en/actions/security-guides/encrypted-secrets



https://docs.github.com/en/rest/actions/secrets?apiVersion=2022-11-28#get-a-repository-public-key

### GitHub API endpoint for creating repository secrets

OWNER_REPO="owner/examplerepo"  # Replace with your repository path

API_URL="https://api.github.com/repos/$OWNER_REPO/actions/secrets"
