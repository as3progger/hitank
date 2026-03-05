# Update a webhook
# Usage: ruby scripts/update_webhook.rb PROJECT_ID WEBHOOK_ID [--url URL] [--events EVENT,EVENT,...]

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID WEBHOOK_ID [--url URL] [--events EVENT,EVENT,...]")
webhook_id = ARGV[1] or abort("Missing WEBHOOK_ID")

body = {}
if (idx = ARGV.index('--url')) && ARGV[idx + 1]
  body['url'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--events')) && ARGV[idx + 1]
  body['events'] = ARGV[idx + 1].split(',')
end

abort("Nothing to update. Use --url or --events") if body.empty?

data = rewrite_request(:patch, "/projects/#{project_id}/webhooks/#{webhook_id}", body: body)

w = data['data'] || data
puts "Updated webhook: #{w['id'] || webhook_id}"
