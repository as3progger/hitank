require_relative 'auth'

board_id = ARGV[0] or abort("Usage: ruby #{__FILE__} BOARD_ID")

data = trello_request(:get, "/boards/#{board_id}/labels", params: { 'fields' => 'id,name,color' })

data.each do |l|
  puts "#{l['id']}\t#{l['name']}\t#{l['color']}"
end
