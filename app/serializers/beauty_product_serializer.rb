class BeautyProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :image_url, :category, :qty, :user_id
end
