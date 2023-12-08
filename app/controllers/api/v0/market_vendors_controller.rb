class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def create
    market = Market.find(params[:id])
    vendor = Vendor.find(params[:id])

    market_vendor = MarketVendor.create(market_vendor_params)

    if market_vendor.save
      render(json: MarketVendorSerializer.new(MarketVendor.create(market_vendor_params)), status: 201)
    else
      render json: {errors: vendor.errors.full_messages}, status: :bad_request
    end
  end

  def destroy
    render(json: Vendor.find(params[:id]).destroy)
  end

  private

  def market_vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end
