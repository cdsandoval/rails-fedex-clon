class AddCityToSenders < ActiveRecord::Migration[5.2]
  def change
    add_column :senders, :city, :string
  end
end
