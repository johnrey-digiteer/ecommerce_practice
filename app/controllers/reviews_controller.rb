class ReviewsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
    def create
        @product = Product.find(params[:product_id])
        existing_review = Review.find_by(user_id: current_user.id, product_id: params[:product_id])

        if existing_review.present?
            flash[:notice] = "You already reviewed the product"
            redirect_to product_path(@product) # halts request cycle
        else
            @review = @product.reviews.create( user_id: current_user.id, product_id:params[:product_id], body: review_params[:body], score: review_params[:score] )
            redirect_to product_path(@product)
        end
    end 

    def update
        @product = Product.find(params[:product_id])
        @review = @product.reviews.find(params[:id])
        if @review.update(review_params)
          redirect_to product_path(@product)
        else
          render :edit, status: :unprocessable_entity
        end
      end
    
    private
        def review_params
            params.require(:review).permit(:body, :score, :reply)
        end

        def require_admin
            if current_user.is_customer?
              flash[:notice] = "You must be an Admin to access that section"
              redirect_to products_path # halts request cycle
            end
          end
end
