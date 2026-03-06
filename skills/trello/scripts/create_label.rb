require_relative 'auth'

board_id = ARGV[0] or abort("Usage: ruby #{__FILE__} BOARD_ID \"Label Name\" [--color COLOR]")
name     = ARGV[1] or abort("Missing label name")

body = { 'name' => name, 'idBoard' => board_id }

if (idx = ARGV.index('--color')) && ARGV[idx + 1]
  body['color'] = ARGV[idx + 1]
end

data = trello_request(:post, "/boards/#{board_id}/labels", body: body)

puts "Label created: #{data['id']}\t#{data['name']}\t#{data['color']}"
