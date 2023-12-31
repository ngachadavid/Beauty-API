class OrdersController < ApplicationController

    before_action :authorize
  
      def make_order
        # TOTAL AMOUNT FOR THE ORDER
        total_amount = 0
  
        #FIND ITEMS IN CART THAT ARE ACTIVE
        cart_items = User.find(uid).carts.filter {|item| item.active}
  
        # CONVERT CART DATA TO JSON STRING
        cart_data = "#{cart_items.map { |item| JSON.unparse(convert_cart_item(item)) }}"
  
        # CALCULATE THE TOTAL PRICE OF ITEMS IN CART
        cart_items.each do |item|
          total_amount += calculate_order_amount(Product.find(item.product_id), item)
          # deactivate cart item
          item.active = false
          item.save
        end
  
        # CREATE ORDER IF THERE WERE ITEMS IN THE CART
        if cart_items.length > 0
          order = Order.create(amount: total_amount, cart_data: cart_data, user_id: uid)
          app_response(status_code: 201, body: order)
        else
          app_response(message: "You do not have any items in the cart!")
        end
      end
  
      def show_orders
        app_response(body: orders)
      end
  
      def filter_orders_with_status
        app_response(body: filter_orders)
      end
  
      def update_order_status
        order = Order.find(params[:order_id])
        if params[:order_status].downcase != "completed"
          order.status = params[:order_status]
          order.save
          app_response(message: "Updated order status as #{params[:order_status]}", body: convert_order(order))
        else
          if all_items_available?
            update_product_store
            app_response(message: "Your item(s) have been ordered successful", body: convert_order(order))
          else
            app_response(message: "You have items in your cart that exceed available stock!")
          end
        end
      end
  
      private  
  
      # Calculate order value
      def calculate_order_amount(product, cart_item)
          product.price * cart_item.qty
      end
  
      # Display cart item as a json
      def convert_cart_item(cart_item)
        product = Product.find(cart_item.product_id)
        {
          product_id: cart_item.product_id,
          product: product.name,
          quantity: cart_item.quantity,
          amount: cart_item.quantity * product.price
        }
      end
  
      # Custom order serializer
      def convert_order(order)
        {
          id: order.id,
          amount: order.amount,
          status: order.status,
          cart: JSON.parse(order.cart_data).map { |cart_item| JSON.parse(cart_item)  },
          user_id: order.user_id
        }
      end
  
      # Fetch user's list of orders
      def orders
        User.find(uid).orders.map { |order| convert_order(order)  }
      end
  
      # If no filter status is provided then use the params provided
      def filter_orders(status: nil)
        orders.filter {|order| order[:status] == (!!status ? status : params[:order_status].downcase)}
      end
  
      # Check whether checked out items are available in stock
      def all_items_available?
        product_ids = []
        product_quantity = []
        order_quantity = []
  
        filter_orders(status: "pending").each do |order|
          order[:cart].each do |cart_item|
            cart_product = cart_item["product_id"]
            cart_quantity = cart_item["quantity"]
  
            if product_ids.include? cart_product
              product_index = product_ids.find_index cart_product
              order_quantity[product_index] += cart_quantity
            else
              product_ids << cart_product
              order_quantity << cart_quantity
              product_quantity << Product.find(cart_product).quantity
            end
  
          end
        end
        # CHECK IF ANY ITEMS ARE OUT OF STOCK (PRODUCT QTY AND ORDER QTY SHOULD BE EQUAL)
        order_quantity == product_quantity
      end
  
      # Reduce items in store once order is made successfully
      def update_product_store
        filter_orders(status: "pending").each do |order|
          order[:cart].each do |cart_item|
            cart_product = cart_item[:product_id]
            cart_quantity = cart_item[:quantity]
            product = Product.find(cart_product)
            product.quantity -= cart_quantity
            product.save
          end
        end
      end
  
  end
  