class RemovePurchasedFromOrderItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :order_items, :purchased, :boolean
  end
end
