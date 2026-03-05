# List databases
# Usage: ruby scripts/databases.rb [--page-size N]

require_relative 'auth'

body = { 'filter' => { 'value' => 'database', 'property' => 'object' } }
if (idx = ARGV.index('--page-size')) && ARGV[idx + 1]
  body['page_size'] = ARGV[idx + 1].to_i
end

data = notion_request(:post, '/search', body: body)

(data['results'] || []).each do |db|
  title = (db['title'] || []).map { |t| t['plain_text'] }.join
  puts "#{db['id']}\t#{title || '-'}"
end
