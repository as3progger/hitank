require_relative 'auth'

board_id = ARGV[0] or abort("Usage: ruby #{__FILE__} BOARD_ID")

data = trello_request(:get, "/boards/#{board_id}", params: { 'fields' => 'id,name,desc,closed,url,dateLastActivity' })

puts "ID:\t#{data['id']}"
puts "Name:\t#{data['name']}"
puts "Desc:\t#{data['desc']}"
puts "Status:\t#{data['closed'] ? 'closed' : 'open'}"
puts "URL:\t#{data['url']}"
puts "Last Activity:\t#{data['dateLastActivity']}"
