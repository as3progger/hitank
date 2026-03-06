require_relative 'auth'

board_id = ARGV[0] or abort("Usage: ruby #{__FILE__} BOARD_ID")

params = { 'fields' => 'id,name,closed,pos' }
if ARGV.include?('--all')
  params['filter'] = 'all'
else
  params['filter'] = 'open'
end

data = trello_request(:get, "/boards/#{board_id}/lists", params: params)

data.each do |l|
  status = l['closed'] ? 'closed' : 'open'
  puts "#{l['id']}\t#{l['name']}\t#{status}\t#{l['pos']}"
end
