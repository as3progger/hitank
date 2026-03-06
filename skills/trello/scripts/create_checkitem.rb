require_relative 'auth'

checklist_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHECKLIST_ID \"Item Name\"")
name         = ARGV[1] or abort("Missing item name")

data = trello_request(:post, "/checklists/#{checklist_id}/checkItems", body: { 'name' => name })

puts "Check item created: #{data['id']}\t#{data['name']}\t#{data['state']}"
