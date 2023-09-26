class WishesController < ApplicationController
  def index
    wishes = OrderItem.where(user_id: current_user.id, status: "Wished").includes(:product).all
    @pagy, @wishes = pagy(wishes, items: 1)
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy

    redirect_to wishes_path, status: :see_other
  end
end
