require "rails_helper"

RSpec.describe "MarketVendors API" do
  it "should create a new marketvendor" do
    market = create(:market)
    vendor = create(:vendor)

    market_vendor_params = {
      market_id: market.id,
      vendor_id: vendor.id
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_id: market.id, vendor_id: vendor.id)

    newest_market_vendor = MarketVendor.last

    expect(response.status).to eq(201)
    expect(response).to be_successful
    expect(MarketVendor.count).to eq(1)

    expect(newest_market_vendor.market_id).to eq(market.id)
    expect(newest_market_vendor.vendor_id).to eq(vendor.id)
  end

  it "should not create a new marketvendor without a vendor or market id" do
    vendor = create(:vendor)

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/market_vendors", headers: headers, params: JSON.generate(vendor_id: vendor.id)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
    expect(MarketVendor.count).to eq(0)

    expect(data).to have_key(:message)
    expect(data[:message]).to be_a(String)
    expect(data[:message]).to eq("Validation failed: Market can't be blank, Vendor can't be blank")
  end

  it "should not create a new marketvendor with a invalid vendor or market id" do
    market = create(:market)
    vendor = create(:vendor)

    market_vendor_params = {
      market_id: market.id,
      vendor_id: vendor.id
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_id: market.id, vendor_id: 987654321)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(MarketVendor.count).to eq(0)

    expect(data).to have_key(:errors)
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=987654321")
  end

  it "should delete marketvendor" do
    market = create(:market)
    vendor = create(:vendor)

    market_vendor = MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
    expect(MarketVendor.count).to eq(1)

    delete "/api/v0/market_vendors/#{market_vendor.id}"

    expect(response).to be_successful
    expect(MarketVendor.count).to eq(0)
    expect { MarketVendor.find(market_vendor.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "returns a 404 if the marketvendor is not found" do
    delete "/api/v0/market_vendors/987654321"

    expect(response).to have_http_status(404)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find MarketVendor with 'id'=987654321")
    expect(data).to have_key(:errors)
    expect(data[:errors].first).to have_key(:status)
    expect(data[:errors].first).to have_key(:title)
  end
end
