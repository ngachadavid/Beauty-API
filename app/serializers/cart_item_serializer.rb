class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity
  belongs_to :beauty_product
  
end
