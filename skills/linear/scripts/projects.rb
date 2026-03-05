# List projects
# Usage: ruby scripts/projects.rb [--limit N]

require_relative 'auth'

limit = 50
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  limit = ARGV[idx + 1].to_i
end

query = <<~GQL
  query($first: Int) {
    projects(first: $first) {
      nodes {
        id name state createdAt
      }
    }
  }
GQL

data = linear_query(query, { 'first' => limit })

(data.dig('projects', 'nodes') || []).each do |p|
  puts "#{p['id']}\t#{p['name']}\t#{p['state'] || '-'}\t#{p['createdAt'] || '-'}"
end
