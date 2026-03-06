require_relative 'auth'

project_id     = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID SERVICE_ID ENVIRONMENT_ID --path MOUNT_PATH")
service_id     = ARGV[1] or abort("Missing SERVICE_ID")
environment_id = ARGV[2] or abort("Missing ENVIRONMENT_ID")

input = {
  'projectId' => project_id,
  'serviceId' => service_id,
  'environmentId' => environment_id
}

if (idx = ARGV.index('--path')) && ARGV[idx + 1]
  input['mountPath'] = ARGV[idx + 1]
else
  abort "Missing --path"
end

query = <<~GQL
  mutation volumeCreate($input: VolumeCreateInput!) {
    volumeCreate(input: $input) {
      id
      name
    }
  }
GQL

data = railway_query(query, { 'input' => input })
v = data['volumeCreate']

puts "Volume created: #{v['id']}\t#{v['name']}"
