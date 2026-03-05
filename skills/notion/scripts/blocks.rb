# List child blocks
# Usage: ruby scripts/blocks.rb BLOCK_ID [--page-size N]

require_relative 'auth'

block_id = ARGV[0] or abort("Usage: ruby #{__FILE__} BLOCK_ID [--page-size N]")

params = {}
if (idx = ARGV.index('--page-size')) && ARGV[idx + 1]
  params['page_size'] = ARGV[idx + 1].to_i
end

data = notion_request(:get, "/blocks/#{block_id}/children", params: params)

(data['results'] || []).each do |block|
  type = block['type']
  text_arr = block.dig(type, 'rich_text') || []
  text = text_arr.map { |t| t['plain_text'] }.join
  puts "#{block['id']}\t#{type}\t#{text}"
end
