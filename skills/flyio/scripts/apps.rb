require_relative 'auth'

org_slug = ARGV[0] || 'personal'

data = flyio_request(:get, '/v1/apps', params: { 'org_slug' => org_slug })

apps = data['apps'] || []
apps.each do |a|
  puts "#{a['name']}\t#{a['status']}\t#{a['organization']['slug']}"
end
