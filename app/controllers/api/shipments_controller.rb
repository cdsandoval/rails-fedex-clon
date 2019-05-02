class Api::ShipmentsController < ApiController

  def index
    
  end

  def search
    if params[:tracking_id]
      shipment = Shipment.find_by(tracking_id: params[:tracking_id])
      if shipment
        render json: shipment
      else
        render json: {errors: {message: "It doesn't exists a shipment with that tracking id" } }, status: 404
      end
    else
      render json: {errors: {message: "You have to pass the argument 'tracking_id'" } }, status: 400
    end
  end
end