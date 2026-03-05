# Start a timer for a task
# Usage: ruby scripts/start_timer.rb TEAM_ID TASK_ID

require_relative 'auth'

team_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TEAM_ID TASK_ID")
task_id = ARGV[1] or abort("Missing TASK_ID")

data = clickup_request(:post, "/team/#{team_id}/time_entries/start", body: { 'tid' => task_id })

puts "Timer started for task #{task_id}"
