require_relative 'auth'

query = <<~GQL
  query {
    regions {
      name
      country
      location
    }
  }
GQL

data = railway_query(query)

(data['regions'] || []).each do |r|
  puts "#{r['name']}\t#{r['country']}\t#{r['location']}"
end
