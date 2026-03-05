# Add a comment to a task
# Usage: ruby scripts/add_comment.rb TASK_ID COMMENT_TEXT

require_relative 'auth'

task_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TASK_ID COMMENT_TEXT")
text    = ARGV[1] or abort("Missing COMMENT_TEXT")

data = clickup_request(:post, "/task/#{task_id}/comment", body: {
  'comment_text' => text,
  'notify_all' => false
})

puts "Comment added: #{data['id']}"
