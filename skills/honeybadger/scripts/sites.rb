# List uptime sites for a project
# Usage: ruby scripts/sites.rb PROJECT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

data = hb_request(:get, "/projects/#{project_id}/sites")

sites = data.is_a?(Array) ? data : data['results'] || []

sites.each do |s|
  puts "#{s['id']}\t#{s['name']}\t#{s['url']}\tstatus: #{s['state'] || s['status']}\tlast_checked: #{s['last_checked_at']}"
end
