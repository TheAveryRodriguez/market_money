require "rails_helper"

RSpec.describe "MarketVendors API" do
  xit "should create a new marketvendor" do
    market = create(:market)
    vendor = create(:vendor)

    market_vendor_params = {
      market_id: market.id,
      vendor_id: vendor.id
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/market_vendors", headers: headers, params: JSON.generate(marketvendor: market_vendor_params)

    newest_market_vendor = MarketVendor.last

    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(MarketVendor.count).to eq(1)

    expect(newest_market_vendor.market_id).to eq(market.id)
    expect(newest_market_vendor.vendor_id).to eq(vendor.id)
  end

  xit "should not create a new marketvendor " do
    vendor_params = {
      description: "The annointed one",
      contact_name: "Gojo Clan Head",
      contact_phone: "123-456-7890",
      credit_accepted: true
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(response).to_not be_successful

    expect(data).to have_key(:errors)
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first).to eq("Name can't be blank")
  end

  xit "should delete marketvendor" do
    vendor = create(:vendor)

    expect(Vendor.count).to eq(1)

    delete "/api/v0/vendors/#{vendor.id}"

    expect(response).to be_successful
    expect(Vendor.count).to eq(0)
    expect { Vendor.find(vendor.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  xit "returns a 404 if the marketvendor is not found" do
    delete "/api/v0/vendors/987654321"

    expect(response).to have_http_status(404)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=987654321")
    expect(data).to have_key(:errors)
    expect(data[:errors].first).to have_key(:status)
    expect(data[:errors].first).to have_key(:title)
  end
end
