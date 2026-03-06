require_relative 'auth'

card_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CARD_ID")

data = trello_request(:get, "/cards/#{card_id}/checklists")

data.each do |cl|
  puts "#{cl['id']}\t#{cl['name']}"
  (cl['checkItems'] || []).each do |ci|
    puts "  #{ci['id']}\t[#{ci['state']}] #{ci['name']}"
  end
end
