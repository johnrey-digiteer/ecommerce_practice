class Product < ApplicationRecord
    has_many :order_items
    validates :name, presence: true
    validates :description, presence: true
    validates :quantity, presence: true
    validates :base_price, presence: true
end
