# Append blocks to a page
# Usage: ruby scripts/append_blocks.rb BLOCK_ID TEXT [--type paragraph|heading_1|heading_2|heading_3|bulleted_list_item|numbered_list_item|to_do|code]

require_relative 'auth'

block_id = ARGV[0] or abort("Usage: ruby #{__FILE__} BLOCK_ID TEXT [--type TYPE]")
text     = ARGV[1] or abort("Usage: ruby #{__FILE__} BLOCK_ID TEXT [--type TYPE]")

block_type = 'paragraph'
if (idx = ARGV.index('--type')) && ARGV[idx + 1]
  block_type = ARGV[idx + 1]
end

block = {
  'object' => 'block',
  'type'   => block_type,
  block_type => {
    'rich_text' => [{ 'type' => 'text', 'text' => { 'content' => text } }]
  }
}

data = notion_request(:patch, "/blocks/#{block_id}/children", body: { 'children' => [block] })

(data['results'] || []).each do |b|
  puts "#{b['id']}\t#{b['type']}"
end
