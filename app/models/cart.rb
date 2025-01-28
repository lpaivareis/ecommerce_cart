class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  has_many :cart_items, dependent: :destroy


  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado

  def mark_as_abandoned
    update(last_interaction_at: Time.current)
  end

  def abandoned?
    last_interaction_at > 3.hours.ago
  end

  def remove_if_abandoned
    destroy if last_interaction_at > 7.days.ago
  end
end
