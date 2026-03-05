# Update a task
# Usage: ruby scripts/update_task.rb TASK_ID JSON_BODY
# Example: ruby scripts/update_task.rb abc123 '{"status":"in progress","priority":2}'

require_relative 'auth'

task_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TASK_ID JSON_BODY")
json    = ARGV[1] or abort("Missing JSON_BODY")

body = JSON.parse(json)
data = clickup_request(:put, "/task/#{task_id}", body: body)

puts "Updated task: #{data['id']} — #{data['name']}"
