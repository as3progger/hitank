# List tabs in a spreadsheet
# Usage: ruby scripts/list_sheets.rb SPREADSHEET_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} SPREADSHEET_ID")

data = sheets_request(TOKEN, :get, "https://sheets.googleapis.com/v4/spreadsheets/#{id}")
data['sheets'].each_with_index do |s, i|
  props = s['properties']
  grid = props['gridProperties']
  puts "#{i}: #{props['title']} (#{grid['rowCount']}x#{grid['columnCount']})"
end
