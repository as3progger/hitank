require_relative 'auth'

project_id     = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID SERVICE_ID ENVIRONMENT_ID [--limit N]")
service_id     = ARGV[1] or abort("Missing SERVICE_ID")
environment_id = ARGV[2] or abort("Missing ENVIRONMENT_ID")

limit = 10
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  limit = ARGV[idx + 1].to_i
end

query = <<~GQL
  query deployments($input: DeploymentListInput!, $first: Int) {
    deployments(input: $input, first: $first) {
      edges {
        node {
          id
          status
          createdAt
          url
          staticUrl
        }
      }
    }
  }
GQL

input = {
  'projectId' => project_id,
  'serviceId' => service_id,
  'environmentId' => environment_id
}

data = railway_query(query, { 'input' => input, 'first' => limit })

edges = data.dig('deployments', 'edges') || []
edges.each do |e|
  d = e['node']
  url = d['url'] || d['staticUrl'] || ''
  puts "#{d['id']}\t#{d['status']}\t#{d['createdAt']}\t#{url}"
end
