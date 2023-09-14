class BeautyProduct < ApplicationRecord
  # belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items 
end
