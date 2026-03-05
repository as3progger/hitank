# Google Sheets API — Auth via Service Account JWT
# Usage: require this file at the beginning of any skill script.
# Provides: TOKEN (String) and sheets_request(method, url, body:)

require 'openssl'
require 'base64'
require 'json'
require 'net/http'
require 'uri'

KEY_FILE = File.expand_path('~/.config/gcloud/sheets-sa-key.json')

unless File.exist?(KEY_FILE)
  abort <<~MSG
    Service Account key not found at #{KEY_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

def b64url(s) = Base64.strict_encode64(s).tr('+/', '-_').delete('=')

def authenticate(key_file)
  kf = JSON.parse(File.read(key_file))
  pk = OpenSSL::PKey::RSA.new(kf['private_key'])
  now = Time.now.to_i

  hdr = b64url(JSON.generate({ alg: 'RS256', typ: 'JWT', kid: kf['private_key_id'] }))
  pay = b64url(JSON.generate({
    iss: kf['client_email'],
    scope: 'https://www.googleapis.com/auth/spreadsheets',
    aud: 'https://oauth2.googleapis.com/token',
    iat: now,
    exp: now + 3600
  }))
  sig = b64url(pk.sign(OpenSSL::Digest::SHA256.new, "#{hdr}.#{pay}"))

  resp = Net::HTTP.post_form(
    URI('https://oauth2.googleapis.com/token'),
    'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    'assertion' => "#{hdr}.#{pay}.#{sig}"
  )

  JSON.parse(resp.body)['access_token']
end

def sheets_request(token, method, url, body: nil)
  uri = URI(url)
  req = case method
        when :get  then Net::HTTP::Get.new(uri)
        when :put  then Net::HTTP::Put.new(uri)
        when :post then Net::HTTP::Post.new(uri)
        end
  req['Authorization'] = "Bearer #{token}"
  if body
    req['Content-Type'] = 'application/json'
    req.body = JSON.generate(body)
  end
  JSON.parse(Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }.body)
end

TOKEN = authenticate(KEY_FILE)
