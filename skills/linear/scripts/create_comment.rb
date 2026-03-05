# Create a comment on an issue
# Usage: ruby scripts/create_comment.rb ISSUE_ID BODY

require_relative 'auth'

issue_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_ID BODY")
body     = ARGV[1] or abort("Missing BODY")

query = <<~GQL
  mutation($input: CommentCreateInput!) {
    commentCreate(input: $input) {
      success
      comment { id body user { name } createdAt }
    }
  }
GQL

data = linear_query(query, { 'input' => { 'issueId' => issue_id, 'body' => body } })
result = data['commentCreate']

if result['success']
  c = result['comment']
  puts "Comment created by #{c.dig('user', 'name') || '-'} at #{c['createdAt'] || '-'}"
  puts c['body']
else
  puts "Failed to create comment"
end
