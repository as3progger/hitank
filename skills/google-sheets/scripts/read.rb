# Read data from a tab/range
# Usage: ruby scripts/read.rb SPREADSHEET_ID [RANGE]
# Default RANGE: entire first tab. Examples: "Sheet1!A1:D10", "Financeiro"

require_relative 'auth'

id    = ARGV[0] or abort("Usage: ruby #{__FILE__} SPREADSHEET_ID [RANGE]")
range = ARGV[1]

url = if range
        encoded = URI.encode_www_form_component(range)
        "https://sheets.googleapis.com/v4/spreadsheets/#{id}/values/#{encoded}"
      else
        # No range: get metadata to find the first tab
        meta = sheets_request(TOKEN, :get, "https://sheets.googleapis.com/v4/spreadsheets/#{id}")
        first_sheet = meta['sheets'][0]['properties']['title']
        encoded = URI.encode_www_form_component(first_sheet)
        "https://sheets.googleapis.com/v4/spreadsheets/#{id}/values/#{encoded}"
      end

data = sheets_request(TOKEN, :get, url)
rows = data['values'] || []

puts JSON.generate(rows)
