# List faults for a project
# Usage: ruby scripts/faults.rb PROJECT_ID [--env ENV] [--resolved]

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID [--env ENV] [--resolved]")

params = []
ARGV[1..].each_with_index do |arg, i|
  case arg
  when '--env'      then params << "environment=#{ARGV[i + 2]}" if ARGV[i + 2]
  when '--resolved' then params << 'resolved=true'
  end
end

path = "/projects/#{project_id}/faults"
path += "?#{params.join('&')}" unless params.empty?

data = hb_request(:get, path)

faults = data.is_a?(Array) ? data : data['results'] || []

faults.each do |f|
  puts "#{f['id']}\t#{f['klass']}\t#{f['message']}\toccurrences: #{f['notices_count']}\tlast: #{f['last_notice_at']}"
end
