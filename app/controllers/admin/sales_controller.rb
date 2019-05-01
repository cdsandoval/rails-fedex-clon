module Admin
  
  class SalesController < ApplicationController

    def report
      authorize User, policy_class: SalesPolicy
    end

  end

end