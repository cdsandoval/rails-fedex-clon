module Admin
  
  class ShipmentsController < ApplicationController

    def new
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

  end

end