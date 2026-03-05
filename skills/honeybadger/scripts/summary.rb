# Fault summary for a project
# Usage: ruby scripts/summary.rb PROJECT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

data = hb_request(:get, "/projects/#{project_id}/faults?resolved=false")
unresolved = data.is_a?(Array) ? data : data['results'] || []

data = hb_request(:get, "/projects/#{project_id}/faults?resolved=true")
resolved = data.is_a?(Array) ? data : data['results'] || []

by_env = {}
(unresolved + resolved).each do |f|
  env = f['environment'] || 'unknown'
  by_env[env] ||= { unresolved: 0, resolved: 0 }
  if f['resolved']
    by_env[env][:resolved] += 1
  else
    by_env[env][:unresolved] += 1
  end
end

puts "Fault Summary for project #{project_id}"
puts ""
puts "By environment:"
by_env.each do |env, counts|
  puts "  #{env}: #{counts[:unresolved]} unresolved, #{counts[:resolved]} resolved"
end
puts ""
puts "Total: #{unresolved.length} unresolved, #{resolved.length} resolved"
