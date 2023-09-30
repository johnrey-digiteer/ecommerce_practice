class Product < ApplicationRecord
    has_many :order_items, dependent: :destroy
    has_many :reviews, dependent: :destroy
    has_many :variants, dependent: :destroy
    accepts_nested_attributes_for :variants, allow_destroy: true

    validates :name, presence: true
    validates :description, presence: true
    validates :quantity, presence: true
    validates :base_price, presence: true
end
