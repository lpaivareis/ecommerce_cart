class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    carts = Cart.where('last_interaction_at < ?', 3.hours.ago)

    Carts::AbandonedService.call(carts)
  end
end
