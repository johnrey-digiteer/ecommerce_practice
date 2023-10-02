class OrderItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_customer, except: [:index, :show]
  # before_action :quantity_validation, only: :create
  def index
    @order_items = OrderItem.where(user_id: current_user.id, status: "Ordered").includes(:product).all
  end

  def show
    @order_item = OrderItem.includes(:product).find(params[:id])
  end

def create
  Product.transaction do
    @product = Product.find(params[:product_id])
    quantity = order_item_param_quantity[:quantity].to_i

    if quantity.blank?
      @order_item = @product.order_items.build(
        user: current_user,
        product: @product,
        quantity: nil,
        status: :Ordered  
      )
      @order_item.errors.add(:quantity, "can't be blank")
      render :show, status: :unprocessable_entity
      return
    end

    ordered_item = current_user.order_items.find_by(product: @product, status: 'Ordered')
    wished_item = current_user.order_items.find_by(product: @product, status: :Wished)

    if wished_item
      wished_item.update(status: :Ordered, quantity: quantity)
      item = wished_item&.persisted?
    elsif ordered_item
      ordered_item.increment(:quantity, quantity).save
      item = ordered_item&.persisted?
    else
      @order_item = current_user.order_items.create(
        product: @product,
        quantity: quantity,
        status: :Ordered
      )
      item = @order_item&.persisted?
    end

    if item
      redirect_to order_items_path
    else
      render :show, status: :unprocessable_entity 
    end
  end
end

def wishlist
  @product = Product.find(params[:id])
  ordered = @product.order_items.find_by(user_id: current_user.id, product_id: @product.id, status: "Ordered")
  ordered&.destroy

  @order_item = @product.order_items.create(user_id: current_user.id, product_id: params[:product_id], status: "Wished")
  item = @order_item.persisted?

  if item
    redirect_to wishes_path
  else
    @reviews = @product.reviews.includes(:user).all
    render "products/show", status: :unprocessable_entity
  end
end

def checkout
  @order_items = OrderItem.where(user_id: current_user.id, status: "Ordered").includes(:product).all

  @order_items.each do |order_item|
    @product = Product.find(order_item.product_id)
    if @product&.quantity.to_i >= order_item.quantity
      @product.update(quantity: @product.quantity - order_item.quantity)
    else
      render :index, status: :unprocessable_entity 
      return
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
end
