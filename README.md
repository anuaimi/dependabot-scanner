# Dependabot Alerts Scanner

This script scans all the github repositories for a user that have dependabot enabled to see if there are any unresolved issues. The code uses a Personal Access Token (PAT) to authenticate with GitHub. Note, when you create the github token, you need to select the `repo` scope if you want it to be able to check private repos. Otherway it will just check public ones.

## Prerequisites

- Ruby 3.1.3 or later
- Bundler
- A GitHub personal access token with the necessary permissions

## Usage

```bash
export GITHUB_TOKEN=<your_github_token>
# note, you can also use an .env file to load the github token
bundle install
ruby dependabot_scanner.rb
```

## Sample Output

```bash
┌ [✔] Scanning 75 repositories
├── [✔] Scanning anuaimi/admob19 ✓
├── [✖] Scanning anuaimi/philofaxy-ui Found 1 alerts for anuaimi/philofaxy-ui
├── [✔] Scanning anuaimi/pivotal_reports ✓


Repository: anuaimi/philofaxy-ui
Total Open Alerts: 1

Alert Details:
The table size exceeds the currently set width.Defaulting to vertical orientation.
┌────────┬──────────────────────────────────────────────────────────────┐
│ CVE_id │ CVE-2024-21538                                               │
│ Mess…  │ Regular Expression Denial of Service (ReDoS) in cross-spawn  │
│ Seve…  │ high                                                         │
│ Crea…  │ 2024-11-24                                                   │
│ URL    │ https://github.com/anuaimi/philofaxy-ui/security/dependabo…  │
└────────┴──────────────────────────────────────────────────────────────┘
```
