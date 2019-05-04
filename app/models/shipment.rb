class Shipment < ApplicationRecord
  belongs_to :user
  belongs_to :sender
  has_many :shipment_locations

  validates :origin_address, :destination_address,:estimated_delivery_date, :reception_date, presence: true
  validates :weight, :freight_value, numericality: { greater_than: 0 }
  validate :delivered_date_after_reception_date, on: :update

  before_create :generate_tracking_id

  def validate_stored?(user)
    history = self.shipment_locations.last
    self.delivered_date.present? ||
    (history &&
    history.city == user.city &&
    history.country == user.country)
  end

  def generate_tracking_id
    self.tracking_id = "T#{DateTime.now.to_i}" unless self.tracking_id
  end

  private
  def delivered_date_after_reception_date
    errors.add(:delivered_date, "must be greater or equal to reception_date") if
      !delivered_date.blank? and delivered_date < reception_date
  end

end
