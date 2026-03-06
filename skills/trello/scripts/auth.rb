# Trello REST API — Auth via API Key + Token
# Usage: require this file at the beginning of any skill script.
# Provides: trello_request(method, path, body:, params:) helper

require 'json'
require 'net/http'
require 'uri'

CREDENTIALS_FILE = File.expand_path('~/.config/trello/credentials.json')
BASE_URL = 'https://api.trello.com/1'

unless File.exist?(CREDENTIALS_FILE)
  abort <<~MSG
    Trello credentials not found at #{CREDENTIALS_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

CREDENTIALS = JSON.parse(File.read(CREDENTIALS_FILE))
TRELLO_KEY   = CREDENTIALS['key']
TRELLO_TOKEN = CREDENTIALS['token']

def trello_request(method, path, body: nil, params: {})
  params = params.merge('key' => TRELLO_KEY, 'token' => TRELLO_TOKEN)
  uri = URI("#{BASE_URL}#{path}")
  uri.query = URI.encode_www_form(params)
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req['Content-Type'] = 'application/json'
  if body
    req.body = JSON.generate(body)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  unless resp.is_a?(Net::HTTPSuccess)
    abort "Trello API error #{resp.code}: #{resp.body}"
  end
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
