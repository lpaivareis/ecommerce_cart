require 'rails_helper'

RSpec.describe Carts::AddItemService do
  describe '.call' do
    let(:cart) { create(:shopping_cart) }
    let(:product) { create(:product, name: "Test Product", price: 10.0) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }
    let(:params) { { product_id: product.id, quantity: 3 } }

    subject { described_class.call(params, cart) }

    context 'when the product already is in the cart' do
      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(3)
      end
    end

    context 'when the product is not in the cart' do
      let(:params) { { product_id: create(:product).id, quantity: 1 } }

      it 'adds the product to the cart' do
        expect { subject }.to change { cart.cart_items.count }.by(1)
      end
    end
  end
end