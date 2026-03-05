# Upload file content to a channel
# Usage: ruby scripts/upload_file.rb CHANNEL_ID CONTENT [--filename NAME] [--title TITLE]

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID CONTENT [--filename NAME] [--title TITLE]")
content    = ARGV[1] or abort("Usage: ruby #{__FILE__} CHANNEL_ID CONTENT [--filename NAME] [--title TITLE]")

body = { channel_id: channel_id, content: content }

if (idx = ARGV.index('--filename')) && ARGV[idx + 1]
  body[:filename] = ARGV[idx + 1]
end
if (idx = ARGV.index('--title')) && ARGV[idx + 1]
  body[:title] = ARGV[idx + 1]
end

data = slack_request(:post, '/files.uploadV2', body: body)

unless data['ok']
  abort "Error: #{data['error'] || 'unknown error'}"
end

puts "File uploaded"
