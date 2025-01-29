# frozen_string_literal: true

class CartsController < ApplicationController
  def create
    result = Carts::CreatorService.call(cart_params, cookies.signed[:cart_id])

    if result.success?
      add_cart_cookie(result.data.id)
      render json: result.data, serializer: CartSerializer
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def cart_params
    params.permit(:product_id, :quantity)
  end

  def add_cart_cookie(cart_id)
    cookies.signed[:cart_id] = {
      value: cart_id,
      expires: 3.hours.from_now,
      httponly: true
    }
  end
end
