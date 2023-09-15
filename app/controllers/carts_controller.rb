class CartsController < ApplicationController
   
    def create
      product = BeautyProduct.find(params[:id])
      quantity = params[:quantity] || 1
      cart_item = CartItem.new(product: product, quantity: quantity)
      if cart_item.save
        render json: { message: "Item added to cart" }, status: :created
      else
        render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def index
      cart_items = CartItem.all
      render json: cart_items
    end
  
    def destroy
      cart_item = CartItem.find(params[:id])
      cart_item.destroy
      head :no_content
    end
   end
  