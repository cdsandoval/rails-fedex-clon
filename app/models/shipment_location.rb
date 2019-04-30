class ShipmentLocation < ApplicationRecord
  belongs_to :shipment
  
  validates :city, :country, :reception_date, presence: true
end
