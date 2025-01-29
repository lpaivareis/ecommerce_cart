class CartSerializer < ActiveModel::Serializer
  attributes :id, :products, :total_price

  def products
    object.cart_items.map do |cart_item|
      CartItemSerializer.new(cart_item).attributes
    end
  end

  def total_price
    products.sum { |product| product[:total_price] }
  end
end