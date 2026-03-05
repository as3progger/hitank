# Honeybadger API — Auth via Personal Token (HTTP Basic Auth)
# Usage: require this file at the beginning of any skill script.
# Provides: hb_request(method, path, body:) helper

require 'json'
require 'net/http'
require 'uri'

TOKEN_FILE = File.expand_path('~/.config/honeybadger/token')
BASE_URL   = 'https://app.honeybadger.io/v2'

unless File.exist?(TOKEN_FILE)
  abort <<~MSG
    Honeybadger token not found at #{TOKEN_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

HB_TOKEN = File.read(TOKEN_FILE).strip

def hb_request(method, path, body: nil)
  uri = URI("#{BASE_URL}#{path}")
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req.basic_auth(HB_TOKEN, '')
  req['Accept'] = 'application/json'
  if body
    req['Content-Type'] = 'application/json'
    req.body = JSON.generate(body)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  JSON.parse(resp.body)
end
