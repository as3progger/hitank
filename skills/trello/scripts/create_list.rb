require_relative 'auth'

board_id = ARGV[0] or abort("Usage: ruby #{__FILE__} BOARD_ID \"List Name\" [--pos POS]")
name     = ARGV[1] or abort("Missing list name")

body = { 'name' => name, 'idBoard' => board_id }

if (idx = ARGV.index('--pos')) && ARGV[idx + 1]
  body['pos'] = ARGV[idx + 1]
end

data = trello_request(:post, '/lists', body: body)

puts "List created: #{data['id']}\t#{data['name']}"
