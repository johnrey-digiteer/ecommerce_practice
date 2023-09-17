class ProductsController < ApplicationController
  def index
    in_stock = if params[:in_stock].present?
        params[:in_stock]
    else
        "In Stock"
    end
    filtered = if params[:filter].present?
      unless in_stock == "Out of Stock"
        Product.where("LOWER(name) LIKE ? AND quantity > 0", "%#{params[:filter].downcase}%").all
      else
        Product.where("LOWER(name) LIKE ? AND quantity <= 0", "%#{params[:filter].downcase}%").all
      end
    else
      unless in_stock == "Out of Stock"
        Product.where("quantity > 0").all
      else
        Product.where("quantity <= 0").all
      end
    end
    @pagy, @products = pagy(filtered.all, items: 3)
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create 
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
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
end
