# List workspaces (teams)
# Usage: ruby scripts/teams.rb

require_relative 'auth'

data = clickup_request(:get, '/team')

data['teams'].each do |t|
  puts "#{t['id']}\t#{t['name']}"
end
