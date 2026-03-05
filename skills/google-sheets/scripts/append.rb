# Append rows at the end of a table
# Usage: ruby scripts/append.rb SPREADSHEET_ID SHEET_NAME JSON_VALUES [INPUT_OPTION]
# JSON_VALUES: array of arrays, e.g.: '[["col1","col2","col3"]]'
# INPUT_OPTION: RAW (default) or USER_ENTERED

require_relative 'auth'

id           = ARGV[0] or abort("Usage: ruby #{__FILE__} SPREADSHEET_ID SHEET_NAME JSON_VALUES [INPUT_OPTION]")
sheet_name   = ARGV[1] or abort("Missing SHEET_NAME")
values_json  = ARGV[2] or abort("Missing JSON_VALUES")
input_option = ARGV[3] || 'RAW'

values  = JSON.parse(values_json)
encoded = URI.encode_www_form_component("#{sheet_name}!A:A")

data = sheets_request(TOKEN, :post,
  "https://sheets.googleapis.com/v4/spreadsheets/#{id}/values/#{encoded}:append?valueInputOption=#{input_option}&insertDataOption=INSERT_ROWS",
  body: { majorDimension: 'ROWS', values: values }
)

puts "Appended: #{data.dig('updates', 'updatedRows')} row(s) to #{data.dig('updates', 'updatedRange')}"
