require_relative 'auth'

app_name   = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME MACHINE_ID [--state STATE] [--timeout SECS]")
machine_id = ARGV[1] or abort("Missing MACHINE_ID")

params = {}

if (idx = ARGV.index('--state')) && ARGV[idx + 1]
  params['state'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--timeout')) && ARGV[idx + 1]
  params['timeout'] = ARGV[idx + 1]
end

flyio_request(:get, "/v1/apps/#{app_name}/machines/#{machine_id}/wait", params: params)

puts "Machine #{machine_id} reached state: #{params['state'] || 'started'}"
