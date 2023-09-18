class CartSerializer < ActiveModel::Serializer
  attributes :id, :beauty_product_id
  has_many :cart_items
  has_many :beauty_products, through: :cart_items
  
end
