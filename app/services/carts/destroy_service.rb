module Carts
  class DestroyService < ApplicationService
    def initialize(cart, product_id)
      @cart = cart
      @product_id = product_id
    end

    def call
      remove_product_from_cart

      success_response(cart)
    rescue ActiveRecord::RecordNotFound => e
      error_response(e.message)
    rescue ActiveRecord::RecordInvalid => e
      error_response(e.record.errors.full_messages)
    end

    private

    attr_reader :cart, :product_id

    def remove_product_from_cart
      raise ActiveRecord::RecordNotFound, "Product Not Found" unless products.exists?

      products.destroy_all
    end

    def products
      cart.cart_items.where(product_id: product_id)
    end
  end
end