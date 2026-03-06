# Fly.io Machines API — Auth via Bearer Token
# Usage: require this file at the beginning of any skill script.
# Provides: flyio_request(method, path, body:, params:) helper

require 'json'
require 'net/http'
require 'uri'

TOKEN_FILE = File.expand_path('~/.config/flyio/token')
BASE_URL   = 'https://api.machines.dev'

unless File.exist?(TOKEN_FILE)
  abort <<~MSG
    Fly.io token not found at #{TOKEN_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

FLY_TOKEN = File.read(TOKEN_FILE).strip

def flyio_request(method, path, body: nil, params: {})
  uri = URI("#{BASE_URL}#{path}")
  uri.query = URI.encode_www_form(params) unless params.empty?
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req['Authorization'] = "Bearer #{FLY_TOKEN}"
  req['Content-Type']  = 'application/json'
  if body
    req.body = JSON.generate(body)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  unless resp.is_a?(Net::HTTPSuccess)
    abort "Fly.io API error #{resp.code}: #{resp.body}"
  end
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
