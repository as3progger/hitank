require_relative 'auth'

app_name  = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME VOLUME_ID --size GB")
volume_id = ARGV[1] or abort("Missing VOLUME_ID")

if (idx = ARGV.index('--size')) && ARGV[idx + 1]
  size = ARGV[idx + 1].to_i
else
  abort "Missing --size"
end

data = flyio_request(:put, "/v1/apps/#{app_name}/volumes/#{volume_id}/extend", body: { 'size_gb' => size })

puts "Volume extended: #{data['id']}\t#{data['name']}\t#{data['size_gb']}GB"
