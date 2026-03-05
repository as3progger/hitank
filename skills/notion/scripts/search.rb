# Search pages and databases
# Usage: ruby scripts/search.rb QUERY [--filter page|database] [--page-size N]

require_relative 'auth'

query = ARGV[0] or abort("Usage: ruby #{__FILE__} QUERY [--filter page|database] [--page-size N]")

body = { 'query' => query }
if (idx = ARGV.index('--filter')) && ARGV[idx + 1]
  body['filter'] = { 'value' => ARGV[idx + 1], 'property' => 'object' }
end
if (idx = ARGV.index('--page-size')) && ARGV[idx + 1]
  body['page_size'] = ARGV[idx + 1].to_i
end

data = notion_request(:post, '/search', body: body)

(data['results'] || []).each do |r|
  title = case r['object']
          when 'page'
            props = r.dig('properties', 'title', 'title') || r.dig('properties', 'Name', 'title') || []
            props.map { |t| t['plain_text'] }.join
          when 'database'
            (r.dig('title') || []).map { |t| t['plain_text'] }.join
          end
  puts "#{r['id']}\t#{r['object']}\t#{title || '-'}"
end
