# List users
# Usage: ruby scripts/users.rb

require_relative 'auth'

data = notion_request(:get, '/users')

(data['results'] || []).each do |user|
  email = user.dig('person', 'email') || '-'
  puts "#{user['id']}\t#{user['type']}\t#{user['name'] || '-'}\t#{email}"
end
