# Delete a webhook
# Usage: ruby scripts/delete_webhook.rb PROJECT_ID WEBHOOK_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID WEBHOOK_ID")
webhook_id = ARGV[1] or abort("Missing WEBHOOK_ID")

rewrite_request(:delete, "/projects/#{project_id}/webhooks/#{webhook_id}")

puts "Deleted webhook: #{webhook_id}"
