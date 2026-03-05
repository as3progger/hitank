# Delete a task
# Usage: ruby scripts/delete_task.rb TASK_ID

require_relative 'auth'

task_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TASK_ID")

clickup_request(:delete, "/task/#{task_id}")

puts "Deleted task: #{task_id}"
