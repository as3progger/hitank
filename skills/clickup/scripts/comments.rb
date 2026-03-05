# List comments on a task
# Usage: ruby scripts/comments.rb TASK_ID

require_relative 'auth'

task_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TASK_ID")

data = clickup_request(:get, "/task/#{task_id}/comment")

(data['comments'] || []).each do |c|
  user = c.dig('user', 'username') || 'unknown'
  text = (c['comment_text'] || '')[0..100]
  puts "#{c['id']}\t#{user}\t#{text}"
end
