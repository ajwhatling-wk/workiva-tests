
require 'json'

describe 'Workiva API' do
	
  # req = {
  #   url: apiUrl,
  #   headers: {
  #     'Content-Type': 'application/json',
  #     'Authorization': `Bearer ${authToken}`
  #   },
  #   body: JSON.stringify({values: data})
  # }

	before do
		response = `curl -X POST \
		--data-urlencode "client_id=fa35fe42f0284f1b85f1c6d2ffe283cd" \
		--data-urlencode "client_secret=b952d6cc76fd3fa444e2756879c0ae608ea0423f2ba261e4" \
		--data-urlencode "grant_type=client_credentials" \
		https://api.wk-dev.wdesk.org/v1beta1/oauth2/token`
		json = JSON.parse response

		@access_token = json['access_token']
	end

	let(:junk_table) {
		{
			"values" => [["hello", "world", "something"],["1", "2", "3"]]
		}.to_json
	}

	skip "it should get spreadsheet meta data" do
		resp = `curl -X GET "$WORKIVA_API_URL/spreadsheets/68f078fd11894b36a4abd387564a1fa1" \
			--header "Authorization: Bearer #@access_token"`

		expect(resp).to match /hot dog/
	end

	skip "should be able to post a table and retrieve it" do
		resp = `curl -X PUT "$WORKIVA_API_URL/spreadsheets/68f078fd11894b36a4abd387564a1fa1/sheets/1d61d9d760034b44a72d8e2d79352843/data" \
			-d '#{junk_table}' \
			--header "Content-Type: application/json" \
			--header "Authorization: Bearer #@access_token"`

		expect(resp).to match /Update successful/

		resp = `curl -X GET "$WORKIVA_API_URL/spreadsheets/68f078fd11894b36a4abd387564a1fa1/sheets/1d61d9d760034b44a72d8e2d79352843/data" \
			--header "Authorization: Bearer #@access_token"`

		expect(resp).to match /hello.*world.*1/
	end

	it "should be able to create and delete spreadsheets" do
		# rename sheet for each test... secure random?
		resp = `curl -X POST "$WORKIVA_API_URL/spreadsheets" \
			-d '{"name":"junksheet3"}' \
			--header "Content-Type: application/json" \
			--header "Authorization: Bearer #@access_token"`

		data = JSON.parse resp
		id = data['data']['id']
		expect(data['data']['name']).to eq "junksheet3"

		resp = `curl -X DELETE "$WORKIVA_API_URL/spreadsheets/#{id}" \
			-w %{http_code} \
			--header "Authorization: Bearer #@access_token"`

		expect(resp).to match /success.*200/
	end
end