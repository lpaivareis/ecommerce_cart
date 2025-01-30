# frozen_string_literal: true

module Carts
  class AddItemService < ApplicationService
    def initialize(params, cart)
      @product_id = params[:product_id]
      @quantity = params[:quantity]
      @cart = cart
    end

    def call
      add_products_to_cart
      cart.touch(:last_interaction_at)

      success_response(cart)
    rescue ActiveRecord::RecordInvalid => e
      error_response(e.record.errors.full_messages)
    end

    private

    attr_reader :cart, :product_id, :quantity

    def add_products_to_cart
      cart_item = cart.cart_items.find_or_initialize_by(product_id: product_id)
      new_quantity = cart_item.quantity.to_i + quantity.to_i
      cart_item.update!(quantity: new_quantity)
    end
  end
end
