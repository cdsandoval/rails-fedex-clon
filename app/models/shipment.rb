class Shipment < ApplicationRecord
  belongs_to :user
  belongs_to :sender
  has_many :shipment_locations

  validates :origin_address, :destination_address, presence: true
  validates :weight, :freight_value, numericality: { greater_than: 0 }

  before_create :generate_tracking_id

  def validate_stored?(user)
    history = self.shipment_locations.last
    history &&
    history.city == user.city &&
    history.country == user.country
  end

  def generate_tracking_id
    self.tracking_id = "T#{DateTime.now.to_i}"
  end

end
