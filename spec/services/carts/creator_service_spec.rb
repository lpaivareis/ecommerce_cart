# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carts::CreatorService do
  let(:product) { create(:product, price: 10.0) }
  let(:params) { { product_id: product.id, quantity: 2 } }

  describe '#call' do
    subject { described_class.call(params, cart_id) }

    context 'when creating a new cart' do
      let(:cart_id) { nil }

      it 'creates a new cart with the product' do
        expect(subject).to be_success
        expect(subject.data).to be_a(Cart)
        expect(subject.data.cart_items.count).to eq(1)
        expect(subject.data.cart_items.first.quantity).to eq(2)
        expect(subject.data.total_price).to eq(20.0)
      end
    end

    context 'when adding to existing cart' do
      let!(:cart) { create(:shopping_cart) }
      let(:cart_id) { cart.id }

      it 'adds new product to existing cart' do
        expect(subject).to be_success
        expect(subject.data.id).to eq(cart.id)
        expect(subject.data.cart_items.count).to eq(1)
      end

      context 'when product already exists in cart' do
        let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 3) }

        it 'updates the quantity of existing product' do
          expect(subject).to be_success
          expect(subject.data.cart_items.count).to eq(1)
          expect(subject.data.cart_items.first.quantity).to eq(5)
          expect(subject.data.total_price).to eq(50.0)
        end
      end
    end

    context 'when cart_id is invalid' do
      let(:cart_id) { 999 }

      it 'creates a new cart' do
        expect(subject).to be_success
        expect(subject.data).to be_a(Cart)
        expect(subject.data.cart_items.count).to eq(1)
      end
    end

    context 'with invalid data' do
      let(:cart_id) { nil }

      context 'when product does not exist' do
        let(:params) { { product_id: 999, quantity: 2 } }

        it 'returns error' do
          expect(subject).not_to be_success
          expect(subject.errors).to be_present
        end
      end

      context 'when quantity is invalid' do
        let(:params) { { product_id: product.id, quantity: -1 } }

        it 'returns error' do
          expect(subject).not_to be_success
          expect(subject.errors).to be_present
        end
      end
    end
  end
end
