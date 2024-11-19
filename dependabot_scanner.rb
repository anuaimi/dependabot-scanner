require 'octokit'
require 'date'
require 'dotenv/load'
require 'tty-spinner'
require 'tty-table'
require 'colorize'

class DependabotScanner
  def initialize
    Dotenv.load
    @github_token = ENV['GITHUB_TOKEN']
    
    if @github_token.nil?
      raise "Please set GITHUB_TOKEN environment variable in .env file"
    end
    
    @client = Octokit::Client.new(access_token: @github_token)
    @client.auto_paginate = true
    @spinner = TTY::Spinner.new("[:spinner] Scanning repositories ...", format: :dots)
  end

  def scan_repositories
    repositories = @client.repositories
    repositories.each do |repo|
      scan_repository(repo)
    end
  end

  def scan_repository(repo)
    begin
      @spinner.spin
      # puts "Scanning repository: #{repo.full_name}"
      # @client.accept = 'application/vnd.github.dorian-preview+json'
      alerts = @client.get("/repos/#{repo.full_name}/dependabot/alerts", state: 'open')
      
      if alerts.any?
        puts "Found #{alerts.count} alerts"
        result = {
          repository: repo.full_name,
          alert_count: alerts.count,
          alerts: alerts.map do |alert|
            {
              package: alert.security_advisory.package.name,
              severity: alert.security_advisory.severity,
              created_at: alert.created_at.to_date.to_s,
              url: alert.html_url
            }
          end
        }
        display_results([result])
      end
      
      @spinner.success("✓")
    rescue Octokit::NotFound
      @spinner.error("✗ Repository not found or no access to security alerts")
    rescue Octokit::Unauthorized
      @spinner.error("✗ Unauthorized - Check your GitHub token permissions")
    rescue => e
      @spinner.error("✗ Error: #{e.message}")
    end
  end

  private

  def display_results(results)
    if results.empty?
      puts "\nNo open Dependabot alerts found in any repositories.".green
      return
    end

    puts "\nOpen Dependabot Alerts Summary:".bold
    puts "===============================".bold

    results.each do |repo_result|
      puts "\nRepository: #{repo_result[:repository]}".blue.bold
      puts "Total Open Alerts: #{repo_result[:alert_count]}".red

      table = TTY::Table.new(
        header: ['Package', 'Severity', 'Created', 'URL'],
        rows: repo_result[:alerts].map do |alert|
          [
            alert[:package],
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
  rescue => e
    puts "Error: #{e.message}".red
    exit 1
  end
end 