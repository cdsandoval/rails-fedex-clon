class Api::Admin::ShipmentsController < ApiController

  def search
    authorize User, policy_class: AdminPolicy
    if params[:tracking_id]
      shipment = Shipment.find_by(tracking_id: params[:tracking_id])
      if shipment
        render json: shipment
      else
        render_error_message("It doesn't exist a shipment with that tracking id", 404)
      end
    else
      render_error_message("You have to pass the argument 'tracking_id'", 400)
    end
  end

  def create
    authorize User, policy_class: AdminPolicy
    shipment = Shipment.new(new_shipment_params)
    if shipment.save
      render json: shipment, status: 201
    else
      render_error_message(shipment.errors.full_messages, 400)
    end
  end

  def update
    authorize User, policy_class: AdminPolicy
    shipment = Shipment.find(params[:id])
    if params[:delivered_date]
      shipment.update(shipment_params)
      ShipmentMailer.with(shipment: shipment).shipment_delivered.deliver_now
      render json: shipment, status: 200
    else
      render_error_message("You have to pass the argument 'delivered_date'", 400)
    end
  end

  private
    
  def shipment_params
    params.permit(:delivered_date)
  end

  def new_shipment_params
    params.permit(:origin_address, :destination_address, :weight, :reception_date, :estimated_delivery_date, :freight_value, :user_id, :sender_id)
  end

  rescue_from(ActiveRecord::RecordNotFound) do |_record_not_found|
    render_error_message("It doesn't exist a shipment with that id", 404)
  end
  
end