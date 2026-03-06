require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID \"Name\" [--repo USER/REPO] [--branch BRANCH] [--image IMAGE]")
name       = ARGV[1] or abort("Missing service name")

input = { 'projectId' => project_id, 'name' => name }

if (idx = ARGV.index('--repo')) && ARGV[idx + 1]
  input['source'] = { 'repo' => ARGV[idx + 1] }
  if (bi = ARGV.index('--branch')) && ARGV[bi + 1]
    input['branch'] = ARGV[bi + 1]
  end
elsif (idx = ARGV.index('--image')) && ARGV[idx + 1]
  input['source'] = { 'image' => ARGV[idx + 1] }
end

query = <<~GQL
  mutation serviceCreate($input: ServiceCreateInput!) {
    serviceCreate(input: $input) {
      id
      name
    }
  }
GQL

data = railway_query(query, { 'input' => input })
s = data['serviceCreate']

puts "Service created: #{s['id']}\t#{s['name']}"
