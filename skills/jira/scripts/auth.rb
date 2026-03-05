# Jira Cloud API v3 — Auth via Basic Auth (email + API token)
# Usage: require this file at the beginning of any skill script.
# Provides: jira_request(method, path, body:, params:) helper

require 'json'
require 'net/http'
require 'uri'
require 'base64'

CONFIG_FILE = File.expand_path('~/.config/jira/config.json')

unless File.exist?(CONFIG_FILE)
  abort <<~MSG
    Jira config not found at #{CONFIG_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

JIRA_CONFIG = JSON.parse(File.read(CONFIG_FILE))
JIRA_DOMAIN = JIRA_CONFIG['domain']
JIRA_EMAIL  = JIRA_CONFIG['email']
JIRA_TOKEN  = JIRA_CONFIG['token']
BASE_URL    = "https://#{JIRA_DOMAIN}.atlassian.net/rest/api/3"
AGILE_URL   = "https://#{JIRA_DOMAIN}.atlassian.net/rest/agile/1.0"

def jira_request(method, path, body: nil, params: {}, agile: false)
  base = agile ? AGILE_URL : BASE_URL
  uri = URI("#{base}#{path}")
  uri.query = URI.encode_www_form(params) unless params.empty?
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req['Authorization'] = "Basic #{Base64.strict_encode64("#{JIRA_EMAIL}:#{JIRA_TOKEN}")}"
  req['Content-Type']  = 'application/json'
  req['Accept']        = 'application/json'
  if body
    req.body = JSON.generate(body)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
