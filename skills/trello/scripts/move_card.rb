require_relative 'auth'

card_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CARD_ID TARGET_LIST_ID [--pos POS]")
list_id = ARGV[1] or abort("Missing TARGET_LIST_ID")

body = { 'idList' => list_id }

if (idx = ARGV.index('--pos')) && ARGV[idx + 1]
  body['pos'] = ARGV[idx + 1]
end

data = trello_request(:put, "/cards/#{card_id}", body: body)

puts "Card moved: #{data['id']}\t#{data['name']}\t-> list #{data['idList']}"
