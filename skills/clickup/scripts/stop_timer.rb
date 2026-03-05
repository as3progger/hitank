# Stop the running timer
# Usage: ruby scripts/stop_timer.rb TEAM_ID

require_relative 'auth'

team_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TEAM_ID")

data = clickup_request(:post, "/team/#{team_id}/time_entries/stop")

puts "Timer stopped"
