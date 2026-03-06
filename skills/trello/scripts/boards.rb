require_relative 'auth'

data = trello_request(:get, '/members/me/boards', params: { 'fields' => 'id,name,desc,closed,url' })

data.each do |b|
  status = b['closed'] ? 'closed' : 'open'
  puts "#{b['id']}\t#{b['name']}\t#{status}\t#{b['url']}"
end
