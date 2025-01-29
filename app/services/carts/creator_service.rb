module Carts
  class CreatorService < ApplicationService
    def initialize(params, cart_id = nil)
      @product_id = params[:product_id]
      @quantity = params[:quantity]

      @cart_id = cart_id
    end

    def call
      define_cart

      success_response(cart)
    rescue ActiveRecord::RecordInvalid => e
      error_response(e.record.errors.full_messages)
    end

    private

    attr_reader :cart, :cart_id, :product_id, :quantity

    def define_cart
      @cart = find_cart_by_session || create_cart
      add_products_to_cart
      update_cart_total

      cart.touch(:last_interaction_at)
    end

    def create_cart
      Cart.create!
    end

    def find_cart_by_session
      Cart.find_by(id: cart_id)
    end

    def add_products_to_cart
      cart_item = cart.cart_items.find_or_initialize_by(product_id: product_id)
      
      new_quantity = if cart_item.new_record?
        quantity.to_i
      else
        cart_item.quantity + quantity.to_i
      end

      cart_item.update!(quantity: new_quantity)
    end

    def update_cart_total
      total = cart.cart_items.sum do |item|
        item.quantity * item.product.price
      end
      
      cart.update!(total_price: total)
    end
  end
end