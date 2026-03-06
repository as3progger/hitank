require_relative 'auth'

card_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CARD_ID [--add \"Comment text\"]")

if (idx = ARGV.index('--add')) && ARGV[idx + 1]
  text = ARGV[idx + 1]
  data = trello_request(:post, "/cards/#{card_id}/actions/comments", body: { 'text' => text })
  puts "Comment added: #{data['id']}"
else
  data = trello_request(:get, "/cards/#{card_id}/actions", params: { 'filter' => 'commentCard' })

  data.each do |a|
    creator = a.dig('memberCreator', 'username') || 'unknown'
    text = a.dig('data', 'text') || ''
    puts "#{a['id']}\t#{a['date']}\t#{creator}\t#{text}"
  end
end
