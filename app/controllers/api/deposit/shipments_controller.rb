class Api::Deposit::ShipmentsController < ApiController

  def search
    authorize Shipment, policy_class: DepositPolicy
    if params[:tracking_id]
      shipment = Shipment.find_by(tracking_id: params[:tracking_id])
      if shipment
        render json: shipment
      else
        render_error_message("It doesn't exists a shipment with that tracking id", 404)
      end
    else
      render_error_message("You have to pass the argument 'tracking_id'", 400)
    end
  end
end