class OrderItem < ApplicationRecord
  belongs_to :user
  belongs_to :product

  enum status: { "Wished" => 0, "Ordered" => 1, "Purchased" => 2 }

  # validates :quantity, presence: true
  validate :validate_quantity_less_than_product_quantity
  validate :validate_unique_user_product_status_combination

  private
    def validate_quantity_less_than_product_quantity
      if quantity.present? && product.present? && quantity > product.quantity
        errors.add(:quantity, "can't be greater than the available product quantity")
      end
    end

    def validate_unique_user_product_status_combination
      if user.present? && product.present? && OrderItem.where(user_id: user.id, product_id: product.id, status: status).where.not(id: id).exists?
        errors.add(:base, "An order item with the same user, product and status already exists")
      end
    end
end
