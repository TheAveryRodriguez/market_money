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

  it "should create a new vendor" do
    vendor_params = {
      name: "Satoru Gojo",
      description: "The annointed one",
      contact_name: "Gojo Clan Head",
      contact_phone: "123-456-7890",
      credit_accepted: true
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

    newest_vendor = Vendor.last

    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(Vendor.count).to eq(2)

    expect(newest_vendor.name).to eq(vendor_params[:name])
    expect(newest_vendor.description).to eq(vendor_params[:description])
    expect(newest_vendor.contact_name).to eq(vendor_params[:contact_name])
    expect(newest_vendor.contact_phone).to eq(vendor_params[:contact_phone])
    expect(newest_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
  end

  it "should not create a new vendor " do
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
end
