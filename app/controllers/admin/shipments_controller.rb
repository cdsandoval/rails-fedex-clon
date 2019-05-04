module Admin
  
  class ShipmentsController < ApplicationController

    def delivered
      authorize User, policy_class: AdminPolicy
      @shipment = Shipment.find_by_tracking_id(params[:tracking_id])

      unless @shipment
        flash[:notice] = "The shipment doesn't exist"
        redirect_to(admin_root_path)
      else
        render :search
      end
    end

    def new
      authorize User, policy_class: AdminPolicy
      @shipment = Shipment.new
    end

    def create
      authorize User, policy_class: AdminPolicy
      @shipment = Shipment.new(new_shipment_params)
      if @shipment.save
        redirect_to admin_mark_delivered_path(tracking_id: @shipment.tracking_id), notice: 'Shipment was successfully created.'
      else
        render :new
      end
    end

    def update
      @shipment = Shipment.find(params[:id])
      if @shipment.update(shipment_params)
        ShipmentMailer.with(shipment: @shipment).shipment_delivered.deliver_now
        flash[:notice] = "Shipment marked as delivered successfuly"
        redirect_to(admin_root_path)
      else
        render :delivered
      end
    end

    private
    
    def shipment_params
      params.require(:shipment).permit(:delivered_date)
    end

    def new_shipment_params
      params.require(:shipment).permit(:origin_address, :destination_address, :weight, :reception_date, :estimated_delivery_date, :freight_value, :user_id, :sender_id)
    end

    rescue_from(ActiveRecord::RecordNotFound) do |_record_not_found|
      flash[:notice] = "The shipment doesn't exist"
      render :delivered
    end

  end

end