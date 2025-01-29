module Carts
  class AbandonedService < ApplicationService
    def initialize(carts)
      @carts = carts
    end

    def call
      mark_abandoned_carts
      remove_expired_carts

      success_response
    end

    private

    def mark_abandoned_carts
      Cart.find_each do |cart|
        cart.mark_as_abandoned
      end
    end

    def remove_expired_carts
      Cart.find_each do |cart|
        cart.remove_if_abandoned
      end
    end
  end
end