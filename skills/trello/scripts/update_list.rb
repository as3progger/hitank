require_relative 'auth'

list_id = ARGV[0] or abort("Usage: ruby #{__FILE__} LIST_ID [--name NAME] [--closed true/false] [--pos POS]")

body = {}

if (idx = ARGV.index('--name')) && ARGV[idx + 1]
  body['name'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--closed')) && ARGV[idx + 1]
  body['closed'] = ARGV[idx + 1] == 'true'
end
if (idx = ARGV.index('--pos')) && ARGV[idx + 1]
  body['pos'] = ARGV[idx + 1]
end

if body.empty?
  abort "No fields to update. Use --name, --closed, --pos"
end

data = trello_request(:put, "/lists/#{list_id}", body: body)

puts "List updated: #{data['id']}\t#{data['name']}"
