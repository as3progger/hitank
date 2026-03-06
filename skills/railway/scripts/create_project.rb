require_relative 'auth'

name = ARGV[0] or abort("Usage: ruby #{__FILE__} \"Project Name\" [--desc DESCRIPTION]")

input = { 'name' => name }

if (idx = ARGV.index('--desc')) && ARGV[idx + 1]
  input['description'] = ARGV[idx + 1]
end

query = <<~GQL
  mutation projectCreate($input: ProjectCreateInput!) {
    projectCreate(input: $input) {
      id
      name
    }
  }
GQL

data = railway_query(query, { 'input' => input })
p = data['projectCreate']

puts "Project created: #{p['id']}\t#{p['name']}"
