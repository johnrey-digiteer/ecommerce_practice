class AddPurchasedToOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :purchased, :boolean, default: false
  end
end
