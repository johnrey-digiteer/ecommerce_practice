class WishesController < ApplicationController
  def index
    @wishes = OrderItem.where(user_id: current_user.id, status: "Wished").includes(:product).all
  end
end
