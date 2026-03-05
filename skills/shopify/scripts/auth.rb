# Shopify Admin API — Auth via Access Token
# Usage: require this file at the beginning of any skill script.
# Provides: shopify_request(method, path, body:, params:) helper

require 'json'
require 'net/http'
require 'uri'

CONFIG_FILE = File.expand_path('~/.config/shopify/config.json')

unless File.exist?(CONFIG_FILE)
  abort <<~MSG
    Shopify config not found at #{CONFIG_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

SHOPIFY_CONFIG = JSON.parse(File.read(CONFIG_FILE))
SHOPIFY_STORE  = SHOPIFY_CONFIG['store']
SHOPIFY_TOKEN  = SHOPIFY_CONFIG['token']
BASE_URL       = "https://#{SHOPIFY_STORE}.myshopify.com/admin/api/2024-01"

def shopify_request(method, path, body: nil, params: {})
  uri = URI("#{BASE_URL}#{path}")
  uri.query = URI.encode_www_form(params) unless params.empty?
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req['X-Shopify-Access-Token'] = SHOPIFY_TOKEN
  req['Content-Type']           = 'application/json'
  if body
    req.body = JSON.generate(body)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
