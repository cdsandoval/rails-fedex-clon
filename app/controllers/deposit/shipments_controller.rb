module Deposit
  
  class ShipmentsController < ApplicationController

    def report
      authorize User, policy_class: SalesPolicy
    end

    def show
      @shipment = Shipment.find_by_tracking_id(params[:tracking_id])

      unless @shipment
        flash[:notice] = "The shipment doesn't exist"
        redirect_to deposit_root_path
      end
    end

    
  end

end