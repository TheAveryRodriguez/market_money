require "rails_helper"

RSpec.describe "Markets API" do
  it "sends a list of markets" do
    create_list(:market, 21)

    get "/api/v0/markets"

    expect(response).to have_http_status(200)
    expect(response).to be_successful

    market_response = JSON.parse(response.body, symbolize_names: true)

    expect(market_response).to have_key(:data)
    expect(market_response[:data]).to be_an(Array)

    expect(market_response[:data].count).to eq(21)

    expect(market_response).to have_key(:data)
    expect(market_response[:data][0][:id]).to be_an(String)
    expect(market_response[:data][0][:id]).to eq("#{Market.first.id}")

    expect(market_response[:data][0]).to have_key(:type)
    expect(market_response[:data][0][:type]).to be_an(String)

    expect(market_response[:data][0]).to have_key(:attributes)
    expect(market_response[:data][0][:attributes]).to be_an(Hash)

    expect(market_response[:data][0][:attributes]).to have_key(:name)
    expect(market_response[:data][0][:attributes][:name]).to be_a(String)

    expect(market_response[:data][0][:attributes]).to have_key(:street)
    expect(market_response[:data][0][:attributes][:street]).to be_a(String)

    expect(market_response[:data][0][:attributes]).to have_key(:city)
    expect(market_response[:data][0][:attributes][:city]).to be_a(String)

    expect(market_response[:data][0][:attributes]).to have_key(:county)
    expect(market_response[:data][0][:attributes][:county]).to be_a(String)

    expect(market_response[:data][0][:attributes]).to have_key(:state)
    expect(market_response[:data][0][:attributes][:state]).to be_a(String)

    expect(market_response[:data][0][:attributes]).to have_key(:zip)
    expect(market_response[:data][0][:attributes][:zip]).to be_a(String)

    expect(market_response[:data][0][:attributes]).to have_key(:lat)
    expect(market_response[:data][0][:attributes][:lat]).to be_a(String)

    expect(market_response[:data][0][:attributes]).to have_key(:lon)
    expect(market_response[:data][0][:attributes][:lon]).to be_a(String)
  end

  it "can get one market by its id" do
    id = create(:market).id

    get "/api/v0/markets/#{id}"

    parsed_market = JSON.parse(response.body, symbolize_names: true)

    market = parsed_market[:data]

    expect(response).to be_successful

    expect(parsed_market).to have_key(:data)
    expect(market).to be_a(Hash)

    expect(market).to have_key(:id)
    expect(market[:id]).to be_a(String)

    expect(market).to have_key(:attributes)
    expect(market[:attributes]).to be_a(Hash)

    expect(market[:attributes]).to have_key(:name)
    expect(market[:attributes][:name]).to be_a(String)

    expect(market[:attributes]).to have_key(:street)
    expect(market[:attributes][:street]).to be_a(String)

    expect(market[:attributes]).to have_key(:city)
    expect(market[:attributes][:city]).to be_a(String)

    expect(market[:attributes]).to have_key(:county)
    expect(market[:attributes][:county]).to be_a(String)

    expect(market[:attributes]).to have_key(:state)
    expect(market[:attributes][:state]).to be_a(String)

    expect(market[:attributes]).to have_key(:zip)
    expect(market[:attributes][:zip]).to be_a(String)

    expect(market[:attributes]).to have_key(:lat)
    expect(market[:attributes][:lat]).to be_a(String)

    expect(market[:attributes]).to have_key(:lon)
    expect(market[:attributes][:lon]).to be_a(String)

    expect(market[:attributes]).to have_key(:vendor_count)
    expect(market[:attributes][:vendor_count]).to be_a(Integer)
  end

  it "returns a 404 if the market is not found" do
    get "/api/v0/markets/123123123123"

    expect(response).to have_http_status(404)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=123123123123")
    expect(data).to have_key(:errors)
    expect(data[:errors].first).to have_key(:status)
    expect(data[:errors].first).to have_key(:title)
  end

  it "returns a list of vendors for a given market" do
    market = create(:market)
    id = market.id
    vendor = create(:vendor)

    market.vendors << vendor

    get "/api/v0/markets/#{id}/vendors"

    expect(response).to have_http_status(200)

    parsed_market = JSON.parse(response.body, symbolize_names: true)

    attributes = parsed_market[:data].first[:attributes]

    expect(response).to be_successful

    expect(market.vendors.count).to eq(1)

    expect(attributes[:name]).to eq("#{market.vendors.first.name}")
    expect(attributes[:description]).to eq("#{market.vendors.first.description}")
    expect(attributes[:contact_name]).to eq("#{market.vendors.first.contact_name}")
    expect(attributes[:contact_phone]).to eq("#{market.vendors.first.contact_phone}")
    expect(attributes[:credit_accepted]).to eq(market.vendors.first.credit_accepted)
  end

  xit "returns a 404 if the vendor is not found" do
    expect(Market.count).to eq(0)

    get "/api/v0/markets/1234567890/vendors"

    expect(response).to have_http_status(404)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=1234567890")
    expect(data).to have_key(:errors)
    expect(data[:errors].first).to have_key(:status)
    expect(data[:errors].first).to have_key(:title)
  end
end
