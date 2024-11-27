# Dependabot Alerts Scanner

This script scans all the github repositories for Dependabot alerts and outputs them in a table format.  The code uses a Personal Access Token (PAT) to authenticate with GitHub. Note, there will only be be dependabot alerts for respos

## Prerequisites

- Ruby 3.1.3 or later
- Bundler
- A GitHub personal access token with the necessary permissions

## Usage

Note, when you create the github token, you need to select the `repo` scope otherwise it will only work for public repositories.

```bash
export GITHUB_TOKEN=<your_github_token>
# note, you can use the .env file to load the github token
bundle install
ruby dependabot_scanner.rb
```
