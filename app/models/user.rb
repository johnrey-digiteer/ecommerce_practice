class User < ApplicationRecord
  has_many :order_items
  has_many :reviews
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { "Admin" => 0, "Customer" => 1 }

  before_save :set_defaults

  after_create :create_order

  def is_customer?
    role == 'Customer'
  end

  private
    def set_defaults
      role ||= "Customer"
    end
end
