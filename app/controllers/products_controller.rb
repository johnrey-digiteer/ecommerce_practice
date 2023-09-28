class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, except: [:index, :show]

  def index
    filtered = if params[:filter].present?
        unless params[:in_stock] == "false"
          Product.where("LOWER(name) LIKE ? AND quantity > 0", "%#{params[:filter].downcase}%").all
        else
          Product.where("LOWER(name) LIKE ? AND quantity <= 0", "%#{params[:filter].downcase}%").all
        end
      else
        unless params[:in_stock] == "false"
          Product.where("quantity > 0").all
        else
          Product.where("quantity <= 0").all
        end
      end
    @pagy, @products = pagy(filtered.all, items: 3)
  end

  def show
    @product = Product.find(params[:id])
    @reviews = @product.reviews.includes(:user).all
  end

  def new
    @product = Product.new
  end

  def create 
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      # respond_to do |format|
      #   format.turbo_stream do
      #     render turbo_stream: turbo_stream.update("new_product",
      #       partial: "products/form",
      #       locals: { product: @product })
      #   end
      #   format.html { render :new, status: :unprocessable_entity }
      # end
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.update(product_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("product",
            partial: "products/product",
            locals: { product: @product })
        end
        format.html { redirect_to @product }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to products_path, status: :see_other
  end

  private
    def product_params
      params.require(:product).permit(:name, :description, :quantity, :base_price)
    end

    def require_admin
      if current_user.is_customer?
        flash[:notice] = "You must be an Admin to access that section"
        redirect_to products_path # halts request cycle
      end
    end
end
