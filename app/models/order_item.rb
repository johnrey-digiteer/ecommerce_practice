class OrderItem < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :quantity, presence: true
  validate :validate_quantity_less_than_product_quantity

  private
    def validate_quantity_less_than_product_quantity
      if quantity.present? && product.present? && quantity > product.quantity
        errors.add(:quantity, "can't be greater than the available product quantity")
      end
    end
end
