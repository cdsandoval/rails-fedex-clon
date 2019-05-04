class Api::Admin::SalesController < ApiController

  def report_top5_countries_senders
    authorize User,:report?, policy_class: SalesPolicy
    shipments = ReportsQueries.new.senders_countries
    render json: shipments
  end

  def report_top5_countries_recipients
    authorize User,:report?, policy_class: SalesPolicy
    shipments = ReportsQueries.new.recipients_countries
    render json: shipments
  end

  def report_top5_packages_sent
    authorize User,:report?, policy_class: SalesPolicy
    senders = ReportsQueries.new.ranked_packages_sent
    render json: senders
  end

  def report_ranked_freight_value
    authorize User,:report?, policy_class: SalesPolicy
    senders = ReportsQueries.new.ranked_freight_value
    render json: senders
  end
end