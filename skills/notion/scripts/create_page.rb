# Create a page
# Usage: ruby scripts/create_page.rb PARENT_ID TITLE [--database]

require_relative 'auth'

parent_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PARENT_ID TITLE [--database]")
title     = ARGV[1] or abort("Usage: ruby #{__FILE__} PARENT_ID TITLE [--database]")
is_db     = ARGV.include?('--database')

parent = if is_db
           { 'database_id' => parent_id }
         else
           { 'page_id' => parent_id }
         end

properties = if is_db
               { 'Name' => { 'title' => [{ 'text' => { 'content' => title } }] } }
             else
               { 'title' => { 'title' => [{ 'text' => { 'content' => title } }] } }
             end

data = notion_request(:post, '/pages', body: {
  'parent'     => parent,
  'properties' => properties
})

puts "#{data['id']}\t#{data['url']}"
