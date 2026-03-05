# Get a single task
# Usage: ruby scripts/task.rb TASK_ID

require_relative 'auth'

task_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TASK_ID")

t = clickup_request(:get, "/task/#{task_id}")

status   = t.dig('status', 'status') || '-'
priority = t.dig('priority', 'priority') || 'none'
assignees = (t['assignees'] || []).map { |a| a['username'] }.join(', ')
assignees = '-' if assignees.empty?
tags = (t['tags'] || []).map { |tag| tag['name'] }.join(', ')
tags = '-' if tags.empty?

puts "id:\t#{t['id']}"
puts "name:\t#{t['name']}"
puts "status:\t#{status}"
puts "priority:\t#{priority}"
puts "assignees:\t#{assignees}"
puts "tags:\t#{tags}"
puts "due_date:\t#{t['due_date'] || '-'}"
puts "url:\t#{t['url'] || '-'}"
puts "description:\t#{(t['description'] || '-')[0..200]}"
