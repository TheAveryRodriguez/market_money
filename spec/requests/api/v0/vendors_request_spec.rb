require "rails_helper"

RSpec.describe "Vendors API" do
  it "can get one vendor by its id" do
    id = create(:vendor).id

    get "/api/v0/vendors/#{id}"

    parsed_vendor = JSON.parse(response.body, symbolize_names: true)

    vendor = parsed_vendor[:data]

    expect(response).to be_successful

    expect(parsed_vendor).to have_key(:data)
    expect(vendor).to be_a(Hash)

    expect(vendor).to have_key(:id)
    expect(vendor[:id]).to be_a(String)

    expect(vendor).to have_key(:attributes)
    expect(vendor[:attributes]).to be_a(Hash)

    expect(vendor[:attributes]).to have_key(:name)
    expect(vendor[:attributes][:name]).to eq(Vendor.first.name)

    expect(vendor[:attributes]).to have_key(:description)
    expect(vendor[:attributes][:description]).to eq(Vendor.first.description)

    expect(vendor[:attributes]).to have_key(:contact_name)
    expect(vendor[:attributes][:contact_name]).to eq(Vendor.first.contact_name)

    expect(vendor[:attributes]).to have_key(:contact_phone)
    expect(vendor[:attributes][:contact_phone]).to eq(Vendor.first.contact_phone)

    expect(vendor[:attributes]).to have_key(:credit_accepted)
    expect(vendor[:attributes][:credit_accepted]).to eq(Vendor.first.credit_accepted)
  end

  it "returns a 404 if the vendor is not found" do
    get "/api/v0/vendors/123123123123"

    expect(response).to have_http_status(404)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=123123123123")
    expect(data).to have_key(:errors)
    expect(data[:errors].first).to have_key(:status)
    expect(data[:errors].first).to have_key(:title)
  end
end
