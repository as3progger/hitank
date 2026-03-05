# List pages (search with page filter)
# Usage: ruby scripts/pages.rb [QUERY] [--page-size N]

require_relative 'auth'

body = { 'filter' => { 'value' => 'page', 'property' => 'object' } }
body['query'] = ARGV[0] if ARGV[0] && !ARGV[0].start_with?('--')
if (idx = ARGV.index('--page-size')) && ARGV[idx + 1]
  body['page_size'] = ARGV[idx + 1].to_i
end

data = notion_request(:post, '/search', body: body)

(data['results'] || []).each do |page|
  props = page.dig('properties', 'title', 'title') || page.dig('properties', 'Name', 'title') || []
  title = props.map { |t| t['plain_text'] }.join
  puts "#{page['id']}\t#{title || '-'}"
end
