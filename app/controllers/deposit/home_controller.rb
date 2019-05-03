module Deposit
  
  class HomeController < ApplicationController

    def index
      authorize User, policy_class: DepositPolicy
    end

    
  end

end