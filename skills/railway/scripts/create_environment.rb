require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID \"Name\" [--ephemeral]")
name       = ARGV[1] or abort("Missing environment name")

input = { 'projectId' => project_id, 'name' => name }

if ARGV.include?('--ephemeral')
  input['ephemeral'] = true
end

query = <<~GQL
  mutation environmentCreate($input: EnvironmentCreateInput!) {
    environmentCreate(input: $input) {
      id
      name
    }
  }
GQL

data = railway_query(query, { 'input' => input })
e = data['environmentCreate']

puts "Environment created: #{e['id']}\t#{e['name']}"
