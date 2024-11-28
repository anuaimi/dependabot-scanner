# Dependabot Alerts Scanner

This script scans all the github repositories for a user that have dependabot enabled to see if there are any unresolved issues. It can also list any repositories that don't have dependabot enabled.

The code uses a Personal Access Token (PAT) to authenticate with GitHub. Note, when you create the github token, you need to select the `repo` scope if you want it to be able to check private repos. Otherway it will just check public ones.

## Prerequisites

- Ruby 3.1.3 or later
- Bundler
- A GitHub personal access token with the necessary permissions

## Usage

```bash
export GITHUB_TOKEN=<your_github_token>
# Note, you can also use an .env file to load the GitHub token
bundle install
./dependabot_scanner.rb [options]
# or `ruby dependabot_scanner.rb [options]`
```

### Options

- `-q`, `--quiet`: Only output any Dependabot alerts (minimal output).
- `--no_dependabot`: List repos without dependabot enabled.
- `--dependabot_alerts`: Check repos for open dependabot alerts (default).
- `-v`, `--version`: current version of the script.
- `-h`, `--help`: Show help message.

## Sample Output

By default, the script will show a spinner for each repository it is scanning. 

```bash
┌ [✔] Scanning 75 repositories
├── [✔] Scanning anuaimi/admob19 ✓
├── [✖] Scanning anuaimi/philofaxy-ui Found 1 alerts for anuaimi/philofaxy-ui
├── [✔] Scanning anuaimi/pivotal_reports ✓
├── [✖] Scanning anuaimi/simplestack Found 1 alerts for anuaimi/simplestack
├── [✔] Scanning anuaimi/spot-tracker ✓

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

There is also a `--quiet` flag that will not show the spinner and will just show the output.

```bash
Inventorying repositories for anuaimi
┌ [✖] Scanning 28 repositories
├── [✖] Scanning anuaimi/philofaxy-ui Found 1 alerts for anuaimi/philofaxy-ui
└── [✖] Scanning anuaimi/simplestack Found 1 alerts for anuaimi/simplestack

Open Dependabot Alerts Summary:
===============================
Found 2 repositories with open alerts

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

The following is a sample output when using the `--no_dependabot` flag.

```bash
Repositories without Dependabot alerts enabled:
  anuaimi/team-info
```

