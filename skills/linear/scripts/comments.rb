# List comments for an issue
# Usage: ruby scripts/comments.rb ISSUE_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_ID")

query = <<~GQL
  query($id: String!) {
    issue(id: $id) {
      comments {
        nodes {
          id body user { name } createdAt
        }
      }
    }
  }
GQL

data = linear_query(query, { 'id' => id })

(data.dig('issue', 'comments', 'nodes') || []).each do |c|
  user = c.dig('user', 'name') || '-'
  puts "#{c['id']}\t#{user}\t#{c['createdAt'] || '-'}\t#{c['body'] || '-'}"
end
