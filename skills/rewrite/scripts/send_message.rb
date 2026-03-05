# Send an SMS message
# Usage: ruby scripts/send_message.rb TO MESSAGE [--metadata KEY=VALUE ...]
# Example: ruby scripts/send_message.rb "+5511999999999" "Hello from Rewrite!"
# Example: ruby scripts/send_message.rb "+5511999999999" "Hi" --metadata campaign=welcome source=api

require_relative 'auth'

to      = ARGV[0] or abort("Usage: ruby #{__FILE__} TO MESSAGE [--metadata KEY=VALUE ...]")
message = ARGV[1] or abort("Missing MESSAGE")

body = { 'to' => to, 'message' => message }

if (idx = ARGV.index('--metadata'))
  metadata = {}
  ARGV[(idx + 1)..].each do |pair|
    break if pair.start_with?('--')
    key, value = pair.split('=', 2)
    metadata[key] = value if key && value
  end
  body['metadata'] = metadata unless metadata.empty?
end

data = rewrite_request(:post, '/messages', body: body)

if data && data['id']
  puts "id:\t#{data['id']}"
  puts "status:\t#{data['status'] || '-'}"
  puts "to:\t#{data['to'] || '-'}"
else
  puts data.inspect
end
