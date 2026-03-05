# Create a task in a list
# Usage: ruby scripts/create_task.rb LIST_ID NAME [--description DESC] [--status STATUS] [--priority N]

require_relative 'auth'

list_id = ARGV[0] or abort("Usage: ruby #{__FILE__} LIST_ID NAME [--description DESC] [--status STATUS] [--priority N]")
name    = ARGV[1] or abort("Missing NAME")

body = { 'name' => name, 'notify_all' => false }

if (idx = ARGV.index('--description')) && ARGV[idx + 1]
  body['description'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--status')) && ARGV[idx + 1]
  body['status'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--priority')) && ARGV[idx + 1]
  body['priority'] = ARGV[idx + 1].to_i
end

data = clickup_request(:post, "/list/#{list_id}/task", body: body)

puts "Created task: #{data['id']} — #{data['name']}"
