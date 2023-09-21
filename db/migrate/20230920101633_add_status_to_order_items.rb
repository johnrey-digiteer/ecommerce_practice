class AddStatusToOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :status, :integer
  end
end
