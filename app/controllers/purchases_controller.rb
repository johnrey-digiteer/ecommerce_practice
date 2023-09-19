class PurchasesController < ApplicationController
  def index
    @order_items = OrderItem.where(user_id: current_user.id, purchased: true).includes(:product).all
  end
end
