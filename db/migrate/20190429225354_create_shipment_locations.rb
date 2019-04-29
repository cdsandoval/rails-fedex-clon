class CreateShipmentLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :shipment_locations do |t|
      t.string :city
      t.string :country
      t.date :reception_date
      t.references :shipment, foreign_key: true

      t.timestamps
    end
  end
end
