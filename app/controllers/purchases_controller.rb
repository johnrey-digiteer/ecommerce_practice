class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_customer
  def index
    query = OrderItem.where(user_id: current_user.id, status: :Purchased)
                    .distinct("DATE(updated_at)")
                    .order(updated_at: :desc)
    @pagy, @order_items_dates = pagy(query, items: 1)
  end

  def show
    order_items = OrderItem.where("DATE(updated_at) IN (?)", params[:id])
                          .includes(:product)
    @pagy, @order_items = pagy(order_items, items: 1)
  end
  
  private
    def require_customer
      unless current_user.is_customer?
        flash[:notice] = "You must be a Customer to access that section"
        redirect_to products_path # halts request cycle
      end
    end
end
