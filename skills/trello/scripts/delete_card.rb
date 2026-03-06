require_relative 'auth'

card_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CARD_ID")

trello_request(:delete, "/cards/#{card_id}")

puts "Card deleted: #{card_id}"
