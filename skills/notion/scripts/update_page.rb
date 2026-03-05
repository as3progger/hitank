# Update page properties
# Usage: ruby scripts/update_page.rb PAGE_ID PROPERTY_NAME VALUE

require_relative 'auth'

page_id  = ARGV[0] or abort("Usage: ruby #{__FILE__} PAGE_ID PROPERTY_NAME VALUE")
prop_name = ARGV[1] or abort("Usage: ruby #{__FILE__} PAGE_ID PROPERTY_NAME VALUE")
value     = ARGV[2] or abort("Usage: ruby #{__FILE__} PAGE_ID PROPERTY_NAME VALUE")

# Fetch current page to detect property type
page = notion_request(:get, "/pages/#{page_id}")
prop = page.dig('properties', prop_name)

properties = if prop && prop['type'] == 'title'
               { prop_name => { 'title' => [{ 'text' => { 'content' => value } }] } }
             else
               { prop_name => { 'rich_text' => [{ 'text' => { 'content' => value } }] } }
             end

data = notion_request(:patch, "/pages/#{page_id}", body: { 'properties' => properties })

puts "#{data['id']}\t#{data['last_edited_time']}"
