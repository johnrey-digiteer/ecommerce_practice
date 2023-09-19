class OrderItemsController < ApplicationController
  def index
    @order_items = OrderItem.where(user_id: current_user.id, purchased: false).includes(:product).all
  end

  def show
    @order_item = OrderItem.includes(:product).find(params[:id])
  end

  def create
    @product = Product.find(params[:product_id])
    @order_item = @product.order_items.create(user_id: current_user.id, product_id: params[:product_id], quantity: order_item_param_quantity[:quantity])
    if @order_item.save
      redirect_to order_items_path
    else
      debugger
      render "products/show", status: :unprocessable_entity
    end
  end

  def checkout
    @order_items = OrderItem.where(user_id: current_user.id, purchased: false).includes(:product).all
    @order_items.each do |order_item|
      @product = Product.find(order_item.product_id)
      if @product && @product.quantity >= order_item.quantity
        @product.update(quantity: @product.quantity - order_item.quantity)
      else
        render :index, status: :unprocessable_entity
      end
    end
    if @order_items.update_all(purchased: true)
      redirect_to purchases
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
end
