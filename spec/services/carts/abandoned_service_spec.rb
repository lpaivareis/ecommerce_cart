# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carts::AbandonedService do
  describe '#call' do
    context 'when cart is abandoned' do
      let!(:cart) { create(:shopping_cart, last_interaction_at: 4.hours.ago) }
      let!(:cart_2) { create(:shopping_cart, last_interaction_at: Time.current - 10.days) }

      it 'marks the cart as abandoned' do
        described_class.new([cart]).call

        cart.reload
        expect(cart.abandoned?).to be true
      end

      it 'removes the cart if abandoned' do
        described_class.new([cart, cart_2]).call

        expect(Cart.count).to eq 1
      end
    end

    context 'when cart is not abandoned' do
      let!(:cart) { create(:shopping_cart, last_interaction_at: Time.current) }
      let!(:cart_2) { create(:shopping_cart, last_interaction_at: Time.current - 2.hours) }

      it 'does not mark the cart as abandoned' do
        described_class.new([cart]).call

        cart.reload
        expect(cart.abandoned?).to be false
      end

      it 'does not remove the cart' do
        described_class.new([cart, cart_2]).call

        expect(Cart.count).to eq 2
      end
    end
  end
end
