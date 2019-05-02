module Deposit
  
  class HomeController < ApplicationController

    def report
      authorize User, policy_class: SalesPolicy
    end

    def index
    end

    
  end

end