class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { "Admin" => 0, "Customer" => 1 }

  before_save :set_defaults

  private
    def set_defaults
      self.role  ||= "Customer"
    end
end
