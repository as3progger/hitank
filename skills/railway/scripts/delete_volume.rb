require_relative 'auth'

volume_id = ARGV[0] or abort("Usage: ruby #{__FILE__} VOLUME_ID")

query = <<~GQL
  mutation volumeDelete($volumeId: String!) {
    volumeDelete(volumeId: $volumeId)
  }
GQL

railway_query(query, { 'volumeId' => volume_id })

puts "Volume deleted: #{volume_id}"
