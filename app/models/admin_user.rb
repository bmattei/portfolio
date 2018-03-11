class AdminUser < ActiveRecord::Base
    devise :database_authenticatable, 
           :recoverable, :rememberable, :trackable, :validatable
  has_many :accounts
end
