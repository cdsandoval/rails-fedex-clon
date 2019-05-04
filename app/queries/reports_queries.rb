class ReportsQueries
  def senders_countries
    Sender.joins(:shipments).group(:country).count.sort_by {|_key, value| value }.reverse.first(5).to_h
  end

  def recipients_countries
    User.joins("INNER JOIN shipments ON users.id = shipments.user_id").select("users.country, count(*) as TOTAL").group(:country).order("TOTAL DESC").limit(5)
  end

  def ranked_packages_sent
    Sender.joins(:shipments).group(:email).count("shipments.id").sort_by {|_key, value| value}.reverse.first(5).to_h
  end

  def ranked_freight_value
    top_sender = Sender.joins(:shipments).group(:email).sum("shipments.freight_value")
    top_sender.each{|k,v| top_sender.delete(k) if v < 1000}.sort_by {|_key, value| value}.reverse
  end
end