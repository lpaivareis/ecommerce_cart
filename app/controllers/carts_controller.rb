# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :set_cart, only: %i[show add_item destroy]

  def show
    render json: @cart, serializer: CartSerializer
  end

  def create
    result = Carts::CreatorService.call(cart_params, session[:cart_id])

    if result.success?
      add_cart_to_session(result.data.id)
      render json: result.data, serializer: CartSerializer, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def add_item
    return render json: { error: "Cart not found" }, status: :not_found unless @cart
  
    result = Carts::AddItemService.call(params, @cart)
  
    if result.success?
      render json: result.data, serializer: CartSerializer
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    result = Carts::DestroyService.call(@cart, params[:product_id])

    if result.success?
      render json: result.data, serializer: CartSerializer
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def cart_params
    params.permit(:product_id, :quantity)
  end

  def add_cart_to_session(cart_id)
    session[:cart_id] = cart_id
  end

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id])
  end
end
