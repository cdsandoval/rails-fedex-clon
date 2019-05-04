module Admin
  class HomeController < ApplicationController
    def index
      authorize User, :search?, policy_class: AdminPolicy
    end
  end
end
