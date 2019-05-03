class ReportsQueries
  def senders_countries
    Shipment.joins(:sender).group('shipments.id, senders.country').order('count(senders.country) DESC').limit(5)
  end

  def recipients_countries
    Shipment.joins(:user).group('shipments.id, users.country').order('count(users.country) DESC').limit(5)
  end

  def ranked_packages_sent
    Sender.joins(:shipments).group('senders.id').order('count(shipments.id) DESC')
  end

  def ranked_freight_value
    Sender.joins(:shipments).group('senders.id').order('sum(shipments.freight_value) DESC').having('sum(shipments.freight_value) > 1000')
  end
end