# Get database details
# Usage: ruby scripts/database.rb DATABASE_ID

require_relative 'auth'

db_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DATABASE_ID")

data = notion_request(:get, "/databases/#{db_id}")

title = (data['title'] || []).map { |t| t['plain_text'] }.join
desc  = (data['description'] || []).map { |t| t['plain_text'] }.join

puts "ID:\t#{data['id']}"
puts "Title:\t#{title}"
puts "Description:\t#{desc}" unless desc.empty?
puts "URL:\t#{data['url']}" if data['url']
puts ""
puts "Properties:"
(data['properties'] || {}).each do |name, prop|
  puts "  #{name}\t#{prop['type']}"
end
