require_relative 'auth'

deployment_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DEPLOYMENT_ID [--type build|runtime] [--limit N]")

limit = 100
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  limit = ARGV[idx + 1].to_i
end

log_type = 'runtime'
if (idx = ARGV.index('--type')) && ARGV[idx + 1]
  log_type = ARGV[idx + 1]
end

if log_type == 'build'
  query = <<~GQL
    query buildLogs($deploymentId: String!, $limit: Int) {
      buildLogs(deploymentId: $deploymentId, limit: $limit) {
        timestamp
        message
        severity
      }
    }
  GQL
  data = railway_query(query, { 'deploymentId' => deployment_id, 'limit' => limit })
  logs = data['buildLogs'] || []
else
  query = <<~GQL
    query deploymentLogs($deploymentId: String!, $limit: Int) {
      deploymentLogs(deploymentId: $deploymentId, limit: $limit) {
        timestamp
        message
        severity
      }
    }
  GQL
  data = railway_query(query, { 'deploymentId' => deployment_id, 'limit' => limit })
  logs = data['deploymentLogs'] || []
end

logs.each do |l|
  puts "#{l['timestamp']}\t#{l['severity']}\t#{l['message']}"
end
