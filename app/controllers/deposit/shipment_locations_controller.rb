module Deposit
  
  class ShipmentLocationsController < ApplicationController   

    def create
      authorize User, policy_class: DepositPolicy
      shipment_id = Shipment.find_by(tracking_id: params[:tracking_id]).id
      reception_date = DateTime.now
      country = current_user.country
      city = current_user.city
      ShipmentLocation.create(shipment_id: shipment_id, reception_date: reception_date, country: country, city: city)
      flash[:notice] = "Shipment checked in successfuly"
      redirect_to search_deposit_shipments_path(tracking_id: params[:tracking_id])
    end
    
  end

end