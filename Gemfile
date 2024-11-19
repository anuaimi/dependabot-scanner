source 'https://rubygems.org'

ruby '3.3.4'

gem 'octokit', '~> 7.1'  # GitHub API client
gem 'dotenv', '~> 2.8'   # For loading environment variables from .env file
gem 'tty-spinner', '~> 0.9.3'  # For showing progress during scanning
gem 'tty-table', '~> 0.12.0'   # For better formatted output
gem 'colorize', '~> 1.1'       # For colored terminal output
gem 'faraday-retry'

group :development do
  gem 'pry', '~> 0.14.2'       # For debugging
  gem 'rubocop', '~> 1.57'     # For code style checking
end

group :test do
  gem 'rspec', '~> 3.12'       # For testing
  gem 'vcr', '~> 6.2'          # For recording HTTP interactions
  gem 'webmock', '~> 3.19'     # For stubbing HTTP requests
end
