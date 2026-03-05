# Create a contact
# Usage: ruby scripts/create_contact.rb EMAIL [--firstname NAME] [--lastname NAME] [--phone PHONE] [--company COMPANY]

require_relative 'auth'

email = ARGV[0] or abort("Usage: ruby #{__FILE__} EMAIL [--firstname NAME] [--lastname NAME] [--phone PHONE] [--company COMPANY]")

props = { 'email' => email }

%w[firstname lastname phone company].each do |field|
  if (idx = ARGV.index("--#{field}")) && ARGV[idx + 1]
    props[field] = ARGV[idx + 1]
  end
end

data = hubspot_request(:post, '/crm/v3/objects/contacts', body: { 'properties' => props })

puts "Created contact: #{data['id']}"
