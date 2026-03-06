require_relative 'auth'

app_name  = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME VOLUME_ID")
volume_id = ARGV[1] or abort("Missing VOLUME_ID")

data = flyio_request(:get, "/v1/apps/#{app_name}/volumes/#{volume_id}/snapshots")

(data || []).each do |s|
  puts "#{s['id']}\t#{s['size']}\t#{s['created_at']}\t#{s['status']}"
end
