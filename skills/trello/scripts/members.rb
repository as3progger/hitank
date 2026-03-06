require_relative 'auth'

board_id = ARGV[0] or abort("Usage: ruby #{__FILE__} BOARD_ID")

data = trello_request(:get, "/boards/#{board_id}/members", params: { 'fields' => 'id,username,fullName' })

data.each do |m|
  puts "#{m['id']}\t#{m['username']}\t#{m['fullName']}"
end
