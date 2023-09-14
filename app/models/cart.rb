class Cart < ApplicationRecord
  # belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :beauty_products, through: :cart_items
end
