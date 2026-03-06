require_relative 'auth'

card_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CARD_ID")

data = trello_request(:get, "/cards/#{card_id}", params: {
  'fields' => 'id,name,desc,due,dueComplete,closed,idList,idBoard,labels,pos,url,dateLastActivity',
  'members' => 'true',
  'member_fields' => 'id,username,fullName',
  'checklists' => 'all',
  'checklist_fields' => 'id,name',
  'checkItemStates_fields' => 'state'
})

puts "ID:\t#{data['id']}"
puts "Name:\t#{data['name']}"
puts "Desc:\t#{data['desc']}"
puts "Due:\t#{data['due'] || 'none'}"
puts "Due Complete:\t#{data['dueComplete']}"
puts "Status:\t#{data['closed'] ? 'closed' : 'open'}"
puts "List ID:\t#{data['idList']}"
puts "Board ID:\t#{data['idBoard']}"
puts "URL:\t#{data['url']}"
puts "Last Activity:\t#{data['dateLastActivity']}"

labels = (data['labels'] || []).map { |l| "#{l['id']}\t#{l['name']}\t#{l['color']}" }
unless labels.empty?
  puts "\nLabels:"
  labels.each { |l| puts l }
end

members = (data['members'] || []).map { |m| "#{m['id']}\t#{m['username']}\t#{m['fullName']}" }
unless members.empty?
  puts "\nMembers:"
  members.each { |m| puts m }
end

checklists = data['checklists'] || []
unless checklists.empty?
  puts "\nChecklists:"
  checklists.each do |cl|
    puts "#{cl['id']}\t#{cl['name']}"
    (cl['checkItems'] || []).each do |ci|
      puts "  #{ci['id']}\t[#{ci['state']}] #{ci['name']}"
    end
  end
end
