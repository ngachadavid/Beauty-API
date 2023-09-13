class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :beauty_product
end
