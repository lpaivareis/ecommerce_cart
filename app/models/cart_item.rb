class CartItem < ApplicationRecord 
  validates_numericality_of :quantity, greater_than: 0

  belongs_to :cart
  belongs_to :product
end