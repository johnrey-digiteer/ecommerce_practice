class Variant < ApplicationRecord
  belongs_to :product

  validates :name, presence: true
  validates :color, presence: true
  validates :size, presence: true

  # enum type: { single_choice: 0, multiple_choice: 1, long_answer: 2 }

  # def self.type_select
  #   types.keys.map { |k| [k.titleize, k] }
  # end
end
