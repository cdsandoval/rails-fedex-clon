class Api::Deposit::ShipmentsLocationController < ApiController

  def history
    shipment_history = ShipmentLocation.where(shipment_id: params[:shipment_id])
    render json: shipment_history
  end

  def create
    shipment_id = Shipment.find_by(tracking_id: params[:tracking_id]).id
    reception_date = DateTime.now
    country = current_user.country
    city = current_user.city
    new_location = ShipmentLocation.create(shipment_id: shipment_id, reception_date: reception_date, country: country, city: city)
    render json: new_location, status: :created
  end
end