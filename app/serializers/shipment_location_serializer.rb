class ShipmentLocationSerializer < ActiveModel::Serializer
  attributes  :id,
              :city,
              :country,
              :reception_date,
              :shipment_id
end
