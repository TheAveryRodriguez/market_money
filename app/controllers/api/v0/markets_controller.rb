class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render(json: MarketSerializer.new(Market.find(params[:id])))
  end

  def search
    city = params[:city]
    state = params[:state]
    name = params[:name]

    if state.nil? || (!city.nil? && state.nil?)
      render json: {error: "Invalid set of parameters. Please provide a valid set of parameters to perform a seach with this endpoint."}, status: :unprocessable_entity
    else
      markets = Market.where("state LIKE ? AND city LIKE ? AND name LIKE ?", "%#{state}%", "%#{city}%", "%#{name}%")
      render json: MarketSerializer.new(markets), status: :ok
    end
  end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end
