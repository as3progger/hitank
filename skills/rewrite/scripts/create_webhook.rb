# Create a webhook
# Usage: ruby scripts/create_webhook.rb PROJECT_ID URL EVENT [EVENT ...]
# Events: sms.queued, sms.delivered, sms.failed, sms.scheduled, sms.canceled
# Example: ruby scripts/create_webhook.rb proj_123 "https://example.com/hook" sms.delivered sms.failed

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID URL EVENT [EVENT ...]")
url        = ARGV[1] or abort("Missing URL")
events     = ARGV[2..] || []
abort("Missing at least one EVENT") if events.empty?

data = rewrite_request(:post, "/projects/#{project_id}/webhooks", body: {
  'url' => url,
  'events' => events
})

w = data['data'] || data
puts "Created webhook: #{w['id']}"
puts "url:\t#{w['url'] || url}"
