require_relative 'auth'

card_id      = ARGV[0] or abort("Usage: ruby #{__FILE__} CARD_ID CHECKITEM_ID [--state complete/incomplete] [--name NAME]")
checkitem_id = ARGV[1] or abort("Missing CHECKITEM_ID")

body = {}

if (idx = ARGV.index('--state')) && ARGV[idx + 1]
  body['state'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--name')) && ARGV[idx + 1]
  body['name'] = ARGV[idx + 1]
end

if body.empty?
  abort "No fields to update. Use --state, --name"
end

data = trello_request(:put, "/cards/#{card_id}/checkItem/#{checkitem_id}", body: body)

puts "Check item updated: #{data['id']}\t[#{data['state']}] #{data['name']}"
