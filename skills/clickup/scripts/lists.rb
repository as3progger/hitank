# List lists in a folder or folderless lists in a space
# Usage: ruby scripts/lists.rb PARENT_ID [--space]
# Default: lists in a folder. Use --space for folderless lists in a space.

require_relative 'auth'

parent_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PARENT_ID [--space]")
is_space = ARGV.include?('--space')

path = if is_space
         "/space/#{parent_id}/list"
       else
         "/folder/#{parent_id}/list"
       end

data = clickup_request(:get, path)

data['lists'].each do |l|
  puts "#{l['id']}\t#{l['name']}"
end
