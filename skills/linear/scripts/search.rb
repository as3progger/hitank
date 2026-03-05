# Search issues
# Usage: ruby scripts/search.rb QUERY

require_relative 'auth'

term = ARGV[0] or abort("Usage: ruby #{__FILE__} QUERY")

query = <<~GQL
  query($term: String!) {
    searchIssues(term: $term) {
      nodes {
        identifier title state { name } assignee { name }
      }
    }
  }
GQL

data = linear_query(query, { 'term' => term })

(data.dig('searchIssues', 'nodes') || []).each do |i|
  state    = i.dig('state', 'name') || '-'
  assignee = i.dig('assignee', 'name') || '-'
  puts "#{i['identifier']}\t#{i['title']}\t#{state}\t#{assignee}"
end
