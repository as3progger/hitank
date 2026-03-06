require_relative 'auth'

query = ARGV[0] or abort("Usage: ruby #{__FILE__} \"query\" [--cards] [--boards] [--limit N]")

params = { 'query' => query }

model_types = []
model_types << 'cards' if ARGV.include?('--cards')
model_types << 'boards' if ARGV.include?('--boards')
model_types << 'members' if ARGV.include?('--members')
model_types << 'organizations' if ARGV.include?('--orgs')
params['modelTypes'] = model_types.join(',') unless model_types.empty?

if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['cards_limit'] = ARGV[idx + 1]
  params['boards_limit'] = ARGV[idx + 1]
end

data = trello_request(:get, '/search', params: params)

cards = data['cards'] || []
unless cards.empty?
  puts "Cards:"
  cards.each do |c|
    puts "  #{c['id']}\t#{c['name']}\t#{c['url']}"
  end
end

boards = data['boards'] || []
unless boards.empty?
  puts "Boards:"
  boards.each do |b|
    puts "  #{b['id']}\t#{b['name']}\t#{b['url']}"
  end
end

members = data['members'] || []
unless members.empty?
  puts "Members:"
  members.each do |m|
    puts "  #{m['id']}\t#{m['username']}\t#{m['fullName']}"
  end
end
