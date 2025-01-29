# spec/services/carts/creator_service_spec.rb
require 'rails_helper'

RSpec.describe Carts::CreatorService do
  let(:product) { create(:product, price: 10.0) }
  let(:params) { { product_id: product.id, quantity: 2 } }
  
  describe '#call' do
    context 'when creating a new cart' do
      it 'creates a new cart with the product' do
        result = described_class.call(params)
        
        expect(result).to be_success
        expect(result.data).to be_a(Cart)
        expect(result.data.cart_items.count).to eq(1)
        expect(result.data.cart_items.first.quantity).to eq(2)
        expect(result.data.total_price).to eq(20.0)
      end
    end

    context 'when adding to existing cart' do
      let!(:cart) { create(:shopping_cart) }
      
      it 'adds new product to existing cart' do
        result = described_class.call(params, cart.id)
        
        expect(result).to be_success
        expect(result.data.id).to eq(cart.id)
        expect(result.data.cart_items.count).to eq(1)
      end

      context 'when product already exists in cart' do
        let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 3) }

        it 'updates the quantity of existing product' do
          result = described_class.call(params, cart.id)
          
          expect(result).to be_success
          expect(result.data.cart_items.count).to eq(1)
          expect(result.data.cart_items.first.quantity).to eq(5) # 3 + 2
          expect(result.data.total_price).to eq(50.0) # 5 * 10
        end
      end
    end

    context 'when cart_id is invalid' do
      it 'creates a new cart' do
        result = described_class.call(params, 999)
        
        expect(result).to be_success
        expect(result.data).to be_a(Cart)
        expect(result.data.cart_items.count).to eq(1)
      end
    end

    context 'with invalid data' do
      context 'when product does not exist' do
        let(:params) { { product_id: 999, quantity: 2 } }

        it 'returns error' do
          result = described_class.call(params)
          
          expect(result).not_to be_success
          expect(result.errors).to be_present
        end
      end

      context 'when quantity is invalid' do
        let(:params) { { product_id: product.id, quantity: -1 } }

        it 'returns error' do
          result = described_class.call(params)
          
          expect(result).not_to be_success
          expect(result.errors).to be_present
        end
      end
    end
  end
end