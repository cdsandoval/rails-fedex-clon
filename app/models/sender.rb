class Sender < ApplicationRecord
  has_many :shipments

  validates :order_id, numericality: { greater_than: 0 }
end