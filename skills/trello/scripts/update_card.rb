require_relative 'auth'

card_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CARD_ID [--name NAME] [--desc DESC] [--due DATE] [--idList LIST_ID] [--closed true/false] [--pos POS]")

body = {}

if (idx = ARGV.index('--name')) && ARGV[idx + 1]
  body['name'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--desc')) && ARGV[idx + 1]
  body['desc'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--due')) && ARGV[idx + 1]
  body['due'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--idList')) && ARGV[idx + 1]
  body['idList'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--closed')) && ARGV[idx + 1]
  body['closed'] = ARGV[idx + 1] == 'true'
end
if (idx = ARGV.index('--pos')) && ARGV[idx + 1]
  body['pos'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--idLabels')) && ARGV[idx + 1]
  body['idLabels'] = ARGV[idx + 1]
end

if body.empty?
  abort "No fields to update. Use --name, --desc, --due, --idList, --closed, --pos, --idLabels"
end

data = trello_request(:put, "/cards/#{card_id}", body: body)

puts "Card updated: #{data['id']}\t#{data['name']}\t#{data['url']}"
