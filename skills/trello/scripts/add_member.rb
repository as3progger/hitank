require_relative 'auth'

card_id   = ARGV[0] or abort("Usage: ruby #{__FILE__} CARD_ID MEMBER_ID")
member_id = ARGV[1] or abort("Missing MEMBER_ID")

data = trello_request(:post, "/cards/#{card_id}/idMembers", body: { 'value' => member_id })

puts "Member added to card"
