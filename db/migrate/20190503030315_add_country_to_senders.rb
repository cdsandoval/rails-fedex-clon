class AddCountryToSenders < ActiveRecord::Migration[5.2]
  def change
    add_column :senders, :country, :string
  end
end
