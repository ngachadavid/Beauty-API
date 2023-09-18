class BeautyProductsController < ApplicationController
    before_action :set_beauty_product, only: %i[ show update destroy ]
  
    # GET /beauty_products
    def index
      @beauty_products = BeautyProduct.all
      render json: @beauty_products
    end
  
    # GET /beauty_products/1
    def show
      render json: @beauty_product
    end
  
    # POST /beauty_products
    def create
      @beauty_product = BeautyProduct.new(beauty_product_params)
  
      if @beauty_product.save
        render json: @beauty_product, status: :created, location: @beauty_product
      else
        render json: @beauty_product.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /beauty_products/1
    def update
      if @beauty_product.update(beauty_product_params)
        render json: @beauty_product
      else
        render json: @beauty_product.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /beauty_products/1
    def destroy
      @beauty_product.destroy
    end
  
    private
    
      # Use callbacks to share common setup or constraints between actions.
      def set_beauty_product
        @beauty_product = BeautyProduct.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def beauty_product_params
        params.require(:beauty_product).permit(:name, :description, :price, :image_url, :category, :qty)
      end
      
  end
  