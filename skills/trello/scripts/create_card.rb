require_relative 'auth'

list_id = ARGV[0] or abort("Usage: ruby #{__FILE__} LIST_ID \"Card Name\" [--desc DESC] [--due DATE] [--idLabels IDS] [--pos POS]")
name    = ARGV[1] or abort("Missing card name")

body = { 'idList' => list_id, 'name' => name }

if (idx = ARGV.index('--desc')) && ARGV[idx + 1]
  body['desc'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--due')) && ARGV[idx + 1]
  body['due'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--idLabels')) && ARGV[idx + 1]
  body['idLabels'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--pos')) && ARGV[idx + 1]
  body['pos'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--idMembers')) && ARGV[idx + 1]
  body['idMembers'] = ARGV[idx + 1]
end

data = trello_request(:post, '/cards', body: body)

puts "Card created: #{data['id']}\t#{data['name']}\t#{data['url']}"
