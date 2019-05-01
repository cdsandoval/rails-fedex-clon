class CreateShipments < ActiveRecord::Migration[5.2]
  def change
    create_table :shipments do |t|
      t.string :tracking_id
      t.string :origin_address
      t.string :destination_address
      t.integer :weight
      t.date :reception_date
      t.date :estimated_delivery_date
      t.date :delivered_date
      t.integer :freight_value
      t.references :user, foreign_key: true
      t.references :sender, foreign_key: true

      t.timestamps
    end

    add_index :shipments, :tracking_id, unique: true
  end
end
