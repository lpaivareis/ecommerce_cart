# frozen_string_literal: true

class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity, :unit_price, :total_price

  def id
    object.product_id
  end

  def name
    object.product.name
  end

  def unit_price
    object.product.price
  end

  def total_price
    object.quantity * object.product.price
  end
end
