require 'rails_helper'

RSpec.describe Carts::DestroyService do
  let(:cart) { create(:shopping_cart) }
  let(:product) { create(:product) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

  let(:subject) { described_class.call(cart, product.id) }

  describe '#call' do
    context 'when product exists in cart' do
      it 'removes product from cart' do
        expect { subject }.to change { cart.cart_items.count }.by(-1)
      end

      it 'returns success response' do
        expect(subject).to be_success
      end
    end

    context 'when product does not exist in cart' do
      let(:subject) { described_class.call(cart, 999) }

      it 'returns error message' do
        expect(subject.errors).to be_present
      end
    end
  end
end