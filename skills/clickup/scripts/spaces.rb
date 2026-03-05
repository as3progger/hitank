# List spaces in a workspace
# Usage: ruby scripts/spaces.rb TEAM_ID

require_relative 'auth'

team_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TEAM_ID")

data = clickup_request(:get, "/team/#{team_id}/space")

data['spaces'].each do |s|
  puts "#{s['id']}\t#{s['name']}"
end
