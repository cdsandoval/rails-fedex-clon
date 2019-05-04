module Admin
  class HomeController < ApplicationController
    def index
      authorize User, :index?, policy_class: AdminPolicy
    end
  end
end
