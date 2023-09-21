class OrderItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_customer, except: [:index, :show]
  before_action :quantity_validation, only: :create
  def index
    @order_items = OrderItem.where(user_id: current_user.id, status: "Ordered").includes(:product).all
  end

  def show
    @order_item = OrderItem.includes(:product).find(params[:id])
  end

  def create
    @product = Product.find(params[:product_id])
    @order_item = @product.order_items.create(user_id: current_user.id, product_id: params[:product_id], quantity: order_item_param_quantity[:quantity], status: "Ordered")
    @wished = @product.order_items.find_by(user_id: current_user.id, product_id: params[:product_id], status: "Wished")
    
    if @wished.present?
      if @wished.update(quantity: order_item_param_quantity[:quantity], status: "Ordered")
        redirect_to order_items_path
      else
        @reviews = @product.reviews.includes(:user).all
        render "products/show", status: :unprocessable_entity
      end
    else
      if @order_item.save
        redirect_to order_items_path
      else
        @reviews = @product.reviews.includes(:user).all
        render "products/show", status: :unprocessable_entity
      end
    end
  end

  def wishlist
    @product = Product.find(params[:id])
    @order_item = @product.order_items.create(user_id: current_user.id, product_id: params[:product_id], status: "Wished")
    @ordered = @product.order_items.find_by(user_id: current_user.id, product_id: params[:product_id], status: "Ordered")
  
    if @ordered.present?
      if @ordered.update(quantity: nil, status: "Wished")
        redirect_to wishes_path
      else
        @reviews = @product.reviews.includes(:user).all
        render "products/show", status: :unprocessable_entity
      end
    else
      if @order_item.save
        redirect_to wishes_path
      else
        @reviews = @product.reviews.includes(:user).all
        render "products/show", status: :unprocessable_entity
      end
    end
  end

  def checkout
    @order_items = OrderItem.where(user_id: current_user.id, status: "Ordered").includes(:product).all
    @order_items.each do |order_item|
      @product = Product.find(order_item.product_id)
      if @product && @product.quantity >= order_item.quantity
        @product.update(quantity: @product.quantity - order_item.quantity)
      else
        render :index, status: :unprocessable_entity
      end
    end
    if @order_items.update_all(status: "Purchased")
      redirect_to purchases_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @order_item = OrderItem.includes(:product).find(params[:id])
  end

  def update
    @order_item = OrderItem.includes(:product).find(params[:id])
    if @order_item.update(quantity: order_item_param_quantity[:quantity])
      redirect_to order_item_path(@order_item)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy

    redirect_to order_items_path, status: :see_other
  end

  private
    def order_item_param_quantity
      params.require(:order_item).permit(:quantity)
    end

    def require_customer
      unless current_user.is_customer?
        flash[:notice] = "You must be a Customer to access that section"
        redirect_to products_path # halts request cycle
      end
    end

    def quantity_validation
      if order_item_param_quantity.present?
        flash[:notice] = "Quantity can't be nil"
        redirect_to products_path # halts request cycle
      end
    end
end
