# Write data to a range
# Usage: ruby scripts/write.rb SPREADSHEET_ID RANGE JSON_VALUES [INPUT_OPTION]
# JSON_VALUES: array of arrays, e.g.: '[["a1","b1"],["a2","b2"]]'
# INPUT_OPTION: RAW (default) or USER_ENTERED (interprets formulas/dates)

require_relative 'auth'

id           = ARGV[0] or abort("Usage: ruby #{__FILE__} SPREADSHEET_ID RANGE JSON_VALUES [INPUT_OPTION]")
range        = ARGV[1] or abort("Missing RANGE")
values_json  = ARGV[2] or abort("Missing JSON_VALUES")
input_option = ARGV[3] || 'RAW'

values  = JSON.parse(values_json)
encoded = URI.encode_www_form_component(range)

data = sheets_request(TOKEN, :put,
  "https://sheets.googleapis.com/v4/spreadsheets/#{id}/values/#{encoded}?valueInputOption=#{input_option}",
  body: { range: range, majorDimension: 'ROWS', values: values }
)

puts "Updated: #{data['updatedCells']} cells in #{data['updatedRange']}"
