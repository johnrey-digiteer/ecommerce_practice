class ReviewsController < ApplicationController
    before_action :authenticate_user!
    # before_action :require_admin, except: :create

    def new
      @product = Product.find(params[:product_id])
    end

    def create
      @product = Product.find(params[:product_id])
      Review.transaction do
        @review = @product.reviews.new(
          user_id: current_user.id,
          product_id: params[:product_id],
          body: review_params[:body],
          score: review_params[:score]
        )
        
        if @review.save
          # ADD IF THERE IS SOMETHING
        end
      end
    end 

    def update
      @product = Product.find(params[:product_id])
      @review = @product.reviews.find(params[:id])
      Review.transaction do
        if @review.update(reply: review_params[:reply])
          # ADD IF THERE IS SOMETHING
        end
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
