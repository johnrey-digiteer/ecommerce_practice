class Product < ApplicationRecord
    validates :name, presence: true
    validates :description, presence: true
    validates :quantity, presence: true
    validates :base_price, presence: true
end
