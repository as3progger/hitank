# List notes (engagements) for a contact, company or deal
# Usage: ruby scripts/notes.rb OBJECT_TYPE OBJECT_ID [--limit N]
# Example: ruby scripts/notes.rb contacts 123

require_relative 'auth'

object_type = ARGV[0] or abort("Usage: ruby #{__FILE__} OBJECT_TYPE OBJECT_ID [--limit N]")
object_id   = ARGV[1] or abort("Missing OBJECT_ID")

limit = 10
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  limit = ARGV[idx + 1].to_i
end

body = {
  'filterGroups' => [{
    'filters' => [{
      'propertyName' => 'associations.#{object_type}',
      'operator' => 'EQ',
      'value' => object_id
    }]
  }],
  'limit' => limit,
  'properties' => ['hs_note_body', 'hs_timestamp', 'hubspot_owner_id']
}

data = hubspot_request(:post, '/crm/v3/objects/notes/search', body: body)

(data['results'] || []).each do |n|
  p = n['properties'] || {}
  body_text = (p['hs_note_body'] || '')[0..100].gsub(/<[^>]+>/, '')
  puts "#{n['id']}\t#{p['hs_timestamp'] || '-'}\t#{body_text}"
end
