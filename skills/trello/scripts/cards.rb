require_relative 'auth'

params = { 'fields' => 'id,name,desc,due,closed,idList,labels,pos,url' }

if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end

if (idx = ARGV.index('--board')) && ARGV[idx + 1]
  board_id = ARGV[idx + 1]
  data = trello_request(:get, "/boards/#{board_id}/cards", params: params)
else
  list_id = ARGV[0] or abort("Usage: ruby #{__FILE__} LIST_ID [--limit N] or --board BOARD_ID [--limit N]")
  data = trello_request(:get, "/lists/#{list_id}/cards", params: params)
end

data.each do |c|
  labels = (c['labels'] || []).map { |l| l['name'].empty? ? l['color'] : l['name'] }.join(', ')
  due = c['due'] || ''
  puts "#{c['id']}\t#{c['name']}\t#{due}\t#{labels}\t#{c['url']}"
end
