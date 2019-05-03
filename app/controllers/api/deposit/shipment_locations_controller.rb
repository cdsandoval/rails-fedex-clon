class Api::Deposit::ShipmentLocationsController < ApiController

  def history
    authorize ShipmentLocation, policy_class: DepositPolicy
    if params[:shipment_id]
      shipment_history = ShipmentLocation.where(shipment_id: params[:shipment_id])
      if shipment_history.count > 0
        render json: shipment_history
      else
        render_error_message("It doesn't exist a shipment location with that shipment_id", :not_found)
      end
    else
      render_error_message("You have to pass the argument 'shipment_id'", :bad_request)
    end
  end

  def create
    authorize ShipmentLocation, policy_class: DepositPolicy
    if params[:tracking_id]
      shipment = Shipment.find_by(tracking_id: params[:tracking_id])
      unless shipment.validate_stored?(current_user)
        reception_date = DateTime.now
        country = current_user.country
        city = current_user.city
        new_location = ShipmentLocation.create(shipment_id: shipment.id, reception_date: reception_date, country: country, city: city)
        render json: new_location, status: :created
      else
        render_error_message("The shipment is already stored in this location", :forbidden)
      end
    else
      render_error_message("You have to pass the argument 'tracking_id'", :bad_request)
    end
  end
end