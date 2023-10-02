class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, except: [:index, :show]

  def index
    products = Product.all

    if params[:filter].present?
      filter = "LOWER(name) ILIKE ?"
      filter_params = "%#{params[:filter]}%"
      products = products.where(filter, filter_params)
    end

    case params[:in_stock]
    when "true"
      products = products.where("quantity > 0")
    when "false"
      products = products.where("quantity <= 0")
    end

    sorting_options = {
      "name_asc" => { name: :asc },
      "name_desc" => { name: :desc },
      "quantity_asc" => { quantity: :asc },
      "quantity_desc" => { quantity: :desc },
      "price_asc" => { base_price: :asc },
      "price_desc" => { base_price: :desc }
    }

    if sorting_options.key?(params[:sort_by])
      products = products.order(sorting_options[params[:sort_by]])
    end

    filtered = products.all

    @pagy, @products = pagy(filtered.all, items: 3)
  end

  def show
    @product = Product.find(params[:id])
    # @reviews = @product.reviews.includes(:user).all
  end

  def new
    @product = Product.new
  end

  def create 
    @product = Product.new(product_params)
    Product.transaction do
      if @product.save
      
      end
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    Product.transaction do
      if @product.update(product_params)
      
      end
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to products_path, status: :see_other
  end

  private

  # def product_params
  #   params.require(:product).permit(:name, :description, :quantity, :base_price,
  #                                   variants_attributes: [
  #                                     :_destroy,
  #                                     :id,
  #                                     :name,
  #                                     :color,
  #                                     :size,
  #                                     :type,
  #                                     options_attributes: [
  #                                       :_destroy,
  #                                       :id,
  #                                       :name,
  #                                       :cost
  #                                     ]
  #                                   ])
  # end

  def product_params
    params.require(:product).permit(:name, :description, :quantity, :base_price,
                                    variants_attributes: [
                                      :_destroy,
                                      :id,
                                      :name,
                                      :color,
                                      :size,
                                      :type
                                    ])
  end


  def require_admin
    if current_user.is_customer?
      flash[:notice] = "You must be an Admin to access that section"
      redirect_to products_path # halts request cycle
    end
  end
end
