# Railway API — Auth via Bearer Token (GraphQL)
# Usage: require this file at the beginning of any skill script.
# Provides: railway_query(query, variables) helper

require 'json'
require 'net/http'
require 'uri'

TOKEN_FILE = File.expand_path('~/.config/railway/token')
API_URL    = 'https://backboard.railway.com/graphql/v2'

unless File.exist?(TOKEN_FILE)
  abort <<~MSG
    Railway token not found at #{TOKEN_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

RAILWAY_TOKEN = File.read(TOKEN_FILE).strip

def railway_query(query, variables = {})
  uri = URI(API_URL)
  req = Net::HTTP::Post.new(uri)
  req['Authorization'] = "Bearer #{RAILWAY_TOKEN}"
  req['Content-Type']  = 'application/json'
  req.body = JSON.generate({ 'query' => query, 'variables' => variables })
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  unless resp.is_a?(Net::HTTPSuccess)
    abort "Railway API error #{resp.code}: #{resp.body}"
  end
  return nil if resp.body.nil? || resp.body.empty?
  data = JSON.parse(resp.body)
  if data['errors']
    abort "GraphQL error: #{data['errors'].map { |e| e['message'] }.join(', ')}"
  end
  data['data']
end
