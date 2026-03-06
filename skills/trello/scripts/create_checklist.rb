require_relative 'auth'

card_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CARD_ID \"Checklist Name\"")
name    = ARGV[1] or abort("Missing checklist name")

data = trello_request(:post, "/cards/#{card_id}/checklists", body: { 'name' => name })

puts "Checklist created: #{data['id']}\t#{data['name']}"
