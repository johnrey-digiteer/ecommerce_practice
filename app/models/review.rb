class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :score, presence: true
  validates :body, presence: true
end
