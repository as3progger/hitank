# List all Honeybadger projects
# Usage: ruby scripts/projects.rb

require_relative 'auth'

data = hb_request(:get, '/projects')

projects = data.is_a?(Array) ? data : data['results'] || []

projects.each do |p|
  env = p['environments']&.map { |e| e['name'] }&.join(', ') || '-'
  fault_count = p['unresolved_fault_count'] || p['fault_count'] || '-'
  puts "#{p['id']}\t#{p['name']}\t[#{env}]\tfaults: #{fault_count}"
end
