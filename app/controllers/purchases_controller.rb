class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_customer
  def index
    @order_items_dates = OrderItem.where(user_id: current_user.id, status: "Purchased")
                          .distinct
                          .pluck("DATE(updated_at)")
  end

  def show
    @order_items = OrderItem.where("DATE(updated_at) IN (?)", params[:id])
                          .includes(:product)
                          .all
  end
  
  private
    def require_customer
      unless current_user.is_customer?
        flash[:notice] = "You must be a Customer to access that section"
        redirect_to products_path # halts request cycle
      end
    end
end
