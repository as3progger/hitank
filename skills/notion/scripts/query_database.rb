# Query a database
# Usage: ruby scripts/query_database.rb DATABASE_ID [--page-size N]

require_relative 'auth'

db_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DATABASE_ID [--page-size N]")

body = {}
if (idx = ARGV.index('--page-size')) && ARGV[idx + 1]
  body['page_size'] = ARGV[idx + 1].to_i
end

data = notion_request(:post, "/databases/#{db_id}/query", body: body)

(data['results'] || []).each do |page|
  props = page['properties'] || {}
  values = props.map do |name, prop|
    val = case prop['type']
          when 'title'
            (prop['title'] || []).map { |t| t['plain_text'] }.join
          when 'rich_text'
            (prop['rich_text'] || []).map { |t| t['plain_text'] }.join
          when 'number'
            prop['number']
          when 'select'
            prop.dig('select', 'name')
          when 'multi_select'
            (prop['multi_select'] || []).map { |s| s['name'] }.join(', ')
          when 'date'
            prop.dig('date', 'start')
          when 'checkbox'
            prop['checkbox']
          when 'url'
            prop['url']
          when 'email'
            prop['email']
          when 'phone_number'
            prop['phone_number']
          when 'status'
            prop.dig('status', 'name')
          else
            nil
          end
    "#{name}=#{val}" if val
  end.compact
  puts "#{page['id']}\t#{values.first(5).join("\t")}"
end
