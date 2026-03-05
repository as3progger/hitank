# Delete a block
# Usage: ruby scripts/delete_block.rb BLOCK_ID

require_relative 'auth'

block_id = ARGV[0] or abort("Usage: ruby #{__FILE__} BLOCK_ID")

notion_request(:delete, "/blocks/#{block_id}")

puts "Deleted block #{block_id}"
