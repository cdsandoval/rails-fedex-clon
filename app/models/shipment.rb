class Shipment < ApplicationRecord
  belongs_to :user
  belongs_to :sender
  has_many :shipment_locations

  validates :origin_address, :destination_address, presence: true
  validates :weight, :freight_value, numericality: { greater_than: 0 }

end
