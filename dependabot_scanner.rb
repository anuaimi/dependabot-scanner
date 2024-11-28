require 'octokit'
require 'date'
require 'dotenv'
require 'tty-spinner'
require 'tty-table'
require 'colorize'
require 'debug'

class DependabotScanner
  def initialize
    env_path = File.join(__dir__, '.env')

    # Load the env file
    Dotenv.load(env_path)
    Dotenv.require_keys('GITHUB_TOKEN')

    @github_token = ENV['GITHUB_TOKEN']
    @client = Octokit::Client.new(access_token: @github_token)
    @client.auto_paginate = true

    @repositories = @client.repositories

    @has_dependabot_enabled = []
    @doesnt_have_dependabot_enabled = []

    # go through repos and divide them into two groups
    inventory_repositories
  end

  def inventory_repositories
    puts "Inventorying repositories for #{@client.user.login}"
    @repositories.each do |repo|
      if has_dependabot_alerts_enabled(repo)
        @has_dependabot_enabled << repo
      else
        @doesnt_have_dependabot_enabled << repo
      end
    end
  end

  def repositories_with_dependabot
    results = []
    @repositories.each do |repo|

      if has_dependabot_alerts_enabled(repo)
        result = scan_repository(repo)
        results << result if result  
      else
        # ignore for now
      end

    end
  end

  def has_dependabot_alerts_enabled(repo)
    @client.vulnerability_alerts_enabled?(repo.id)
  end

  def scan_repositories
    results = []
    @spinners = TTY::Spinner::Multi.new("[:spinner] Scanning #{@has_dependabot_enabled.count} repositories")
    @has_dependabot_enabled.each do |repo|
      result = scan_repository(repo)
      results << result if result  
    end

    display_results(results)
  end

  def scan_repository(repo)
    spinner = @spinners.register("[:spinner] Scanning #{repo.full_name}")
    spinner.auto_spin
    
    result = nil
    begin
      alerts = @client.get("/repos/#{repo.full_name}/dependabot/alerts", state: 'open')

      if alerts.any?
        spinner.error("Found #{alerts.count} alerts for #{repo.full_name}")
        
        result = {
          repository: repo.full_name,
          alert_count: alerts.count,
          alert_details: alerts.map do |alert|
            {
              message: alert.security_advisory.summary,
              cve_id: alert.security_advisory.cve_id,
              # package: alert.security_advisory.package.name,
              severity: alert.security_advisory.severity,
              created_at: alert.created_at.to_date.to_s,
              url: alert.html_url
            }
          end
        }
      else
        spinner.success('✓')
      end
    rescue Octokit::NotFound
      spinner.error('✗ Repository not found or no access to security alerts')
    rescue Octokit::Unauthorized
      spinner.error('✗ Unauthorized - Check your GitHub token permissions')
    rescue StandardError => e
      message = e.message.split(":")[2]
      spinner.stop("✗ #{message}")
    end
    
    result
  end

  private

  # display a link that can be clicked in the terminal
  def print_clickable_link(url, text)
    # ANSI escape sequences for clickable links
    puts "\e]8;;#{url}\e\\#{text}\e]8;;\e\\"
  end

  def display_results(results)
    if results.empty?
      puts "\nNo open Dependabot alerts found in any repositories.".green
      return
    end

    puts "\nOpen Dependabot Alerts Summary:".bold
    puts '==============================='.bold

    puts "Found #{results.count} repositories with open alerts"
    #put a breakpoint here  
    results.each do |repo_result|
      puts "\nRepository: #{repo_result[:repository]}".blue.bold
      puts "Total Open Alerts: #{repo_result[:alert_count]}".red

      table = TTY::Table.new(
        header: %w[CVE_id Message Severity Created URL],
        rows: repo_result[:alert_details].map do |alert|
          [
            alert[:cve_id],
            alert[:message],
            colorize_severity(alert[:severity]),
            alert[:created_at],
            alert[:url]
          ]
        end
      )

      puts "\nAlert Details:"
      puts table.render(:unicode, padding: [0, 1])
    end
  end

  def colorize_severity(severity)
    case severity.downcase
    when 'critical'
      severity.red.bold
    when 'high'
      severity.red
    when 'medium'
      severity.yellow
    when 'low'
      severity.green
    else
      severity
    end
  end
end

# Run the scanner
if __FILE__ == $0
  begin
    scanner = DependabotScanner.new
    scanner.scan_repositories
  rescue StandardError => e
    puts "Error: #{e.message}".red
    exit 1
  end
end
