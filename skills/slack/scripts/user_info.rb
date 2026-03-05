# Get user info
# Usage: ruby scripts/user_info.rb USER_ID

require_relative 'auth'

user_id = ARGV[0] or abort("Usage: ruby #{__FILE__} USER_ID")

data = slack_request(:get, '/users.info', params: { 'user' => user_id })

unless data['ok']
  abort "Error: #{data['error'] || 'unknown error'}"
end

u = data['user']
profile = u['profile'] || {}
puts "id\t#{u['id']}"
puts "name\t#{u['name'] || '-'}"
puts "real_name\t#{u['real_name'] || '-'}"
puts "email\t#{profile['email'] || '-'}"
puts "title\t#{profile['title'] || '-'}"
puts "status_text\t#{profile['status_text'] || '-'}"
