module Admin
  
  class ShipmentsController < ApplicationController

    before_action :authorization_admin

    def new
      @shipment = Shipment.new
      @users = User.all
      @senders = Sender.all
    end

    def create
      @shipment = Shipment.new(new_shipment_params)
      if @shipment.save
        redirect_to shipment_path(@shipment), notice: 'Shipment was successfully created.'
      else
        render :new
      end
    end

    def delivered
      @shipment = Shipment.find_by_tracking_id(params[:tracking_id])

      unless @shipment
        flash[:notice] = "The shipment doesn't exist"
        redirect_to(admin_root_path)
      else
        render :delivered
      end
    end

    def update
      
      shipment = Shipment.find(params[:id])
      if shipment.update(shipment_params)
        ShipmentMailer.with(shipment: shipment).shipment_delivered.deliver_now
        flash[:notice] = "Shipment marked as delivered successfuly"
        redirect_to(admin_root_path)
      else
        flash[:notice] = "The shipment doesn't exist"
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

    def authorization_admin
      authorize User, :new?, policy_class: AdminPolicy
    end

  end

end