module Admin
  
  class SalesController < ApplicationController

    def report
      authorize User, policy_class: SalesPolicy
    end

    def report_top5_countries_senders
      @shipments = ReportsQueries.new.senders_countries
    end
  
    def report_top5_countries_recipients
      @shipments = ReportsQueries.new.recipients_countries
    end

    def report_top5_packages_sent
      @senders = ReportsQueries.new.ranked_packages_sent
    end

    def report_ranked_freight_value
      @senders = ReportsQueries.new.ranked_freight_value
    end
  end

end