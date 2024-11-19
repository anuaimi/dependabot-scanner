# Dependabot Alerts Scanner

This script scans all the github repositories for Dependabot alerts and outputs them in a table format.  The code uses a Personal Access Token (PAT) to authenticate with GitHub. Note, there will only be be dependabot alerts for respos

## Prerequisites

- Ruby 3.1.3 or later
- Bundler
- A GitHub personal access token with the necessary permissions

```bash
export GITHUB_TOKEN=<your_github_token>
bundle install
ruby dependabot_scanner.rb
```
