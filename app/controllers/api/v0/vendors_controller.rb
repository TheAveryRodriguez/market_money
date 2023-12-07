class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  def index
    render json: VendorSerializer.new(Vendor.all)
  end

  def show
    render(json: VendorSerializer.new(Vendor.find(params[:id])))
  end

  def create
    vendor = Vendor.create(vendor_params)
    if vendor.save
      render(json: VendorSerializer.new(Vendor.create(vendor_params)), status: 201)
    else
      render json: {errors: vendor.errors.full_messages}, status: :bad_request
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end
