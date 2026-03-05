# List outages for an uptime site
# Usage: ruby scripts/outages.rb PROJECT_ID SITE_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID SITE_ID")
site_id    = ARGV[1] or abort("Missing SITE_ID")

data = hb_request(:get, "/projects/#{project_id}/sites/#{site_id}/outages")

outages = data.is_a?(Array) ? data : data['results'] || []

outages.each do |o|
  duration = o['duration'] || '-'
  puts "#{o['started_at']}\t#{o['ended_at'] || 'ongoing'}\tduration: #{duration}s"
end
