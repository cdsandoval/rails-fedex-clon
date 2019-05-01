class ShipmentController < ApplicationController
  
  def show
    @shipment = Shipment.find_by_tracking_id(params[:tracking_id])

    unless @shipment
      flash[:notice] = "The shipment doesn't exist"
      redirect_to root_path
    end
  end

end


  

  

  

