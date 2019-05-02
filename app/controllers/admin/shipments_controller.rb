module Admin
  
  class ShipmentsController < ApplicationController

    def edit
      @shipment = Shipment.find(params[:id])
    end

    def update
      shipment = Shipment.find(params[:id])
      if shipment.update(shipment_params)
        ShipmentMailer.with(shipment: shipment).shipment_delivered.deliver_now
        redirect_to(root_path)
      else
        render :edit
      end
    end

    private
    def shipment_params
      params.require(:shipment).permit(:delivered_date)
    end

  end

end