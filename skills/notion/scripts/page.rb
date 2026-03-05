# Get page details
# Usage: ruby scripts/page.rb PAGE_ID

require_relative 'auth'

page_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PAGE_ID")

data = notion_request(:get, "/pages/#{page_id}")

puts "ID:\t#{data['id']}"
puts "Created:\t#{data['created_time']}"
puts "Edited:\t#{data['last_edited_time']}"
puts "URL:\t#{data['url']}" if data['url']
puts ""
puts "Properties:"
(data['properties'] || {}).each do |name, prop|
  val = case prop['type']
        when 'title'
          (prop['title'] || []).map { |t| t['plain_text'] }.join
        when 'rich_text'
          (prop['rich_text'] || []).map { |t| t['plain_text'] }.join
        when 'number'
          prop['number']
        when 'select'
          prop.dig('select', 'name')
        when 'multi_select'
          (prop['multi_select'] || []).map { |s| s['name'] }.join(', ')
        when 'date'
          prop.dig('date', 'start')
        when 'checkbox'
          prop['checkbox']
        when 'url'
          prop['url']
        when 'email'
          prop['email']
        when 'phone_number'
          prop['phone_number']
        when 'status'
          prop.dig('status', 'name')
        else
          nil
        end
  puts "  #{name} (#{prop['type']}):\t#{val}" if val
end
