# frozen_string_literal: true

class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    carts = Cart.where('last_interaction_at < ?', 3.hours.ago)

    Carts::AbandonedService.call(carts)
  end
end
