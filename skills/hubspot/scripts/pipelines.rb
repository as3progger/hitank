# List pipelines and stages
# Usage: ruby scripts/pipelines.rb [OBJECT_TYPE]
# OBJECT_TYPE: deals (default) or tickets

require_relative 'auth'

object_type = ARGV[0] || 'deals'

data = hubspot_request(:get, "/crm/v3/pipelines/#{object_type}")

(data['results'] || []).each do |p|
  puts "Pipeline: #{p['id']}\t#{p['label']}"
  (p['stages'] || []).each do |s|
    puts "  #{s['id']}\t#{s['label']}\torder:#{s['displayOrder']}"
  end
end
