# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/carts', type: :request do
  describe 'POST /add_items' do
    let(:cart) { create(:shopping_cart) }
    let(:product) { create(:product, name: 'Test Product', price: 10.0) }

    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    before do
      session_double = { cart_id: cart.id }
      def session_double.loaded?
        true
      end

      def session_double.enabled?
        true
      end

      allow_any_instance_of(ActionDispatch::Request)
        .to receive(:session)
        .and_return(session_double)
    end

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end

  describe 'POST /carts' do
    let(:product) { create(:product, price: 10.0) }
    let(:params) { { product_id: product.id, quantity: 2 } }

    subject(:make_request) { post '/carts', params: params, as: :json }

    context 'when cart already exists in cookies' do
      let(:cart) { create(:shopping_cart) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

      before do
        session_double = { cart_id: cart.id }
        def session_double.loaded?
          true
        end

        def session_double.enabled?
          true
        end

        allow_any_instance_of(ActionDispatch::Request)
          .to receive(:session)
          .and_return(session_double)
      end

      it 'returns success status' do
        make_request
        expect(response).to have_http_status(:success)
      end
    end

    context 'when creating a new cart' do
      before do
        session_double = { cart_id: nil }
        def session_double.loaded?
          true
        end

        def session_double.enabled?
          true
        end

        allow_any_instance_of(ActionDispatch::Request)
          .to receive(:session)
          .and_return(session_double)
      end

      it 'returns success status' do
        make_request
        expect(response).to have_http_status(:success)
      end

      it 'update quantity of cart' do
        expect { make_request }.to change { Cart.count }.by(1)
      end
    end

    context 'when service returns error' do
      before do
        allow(Carts::CreatorService).to receive(:call).and_return(
          OpenStruct.new(success?: false, errors: ['Product must exist'])
        )
      end

      it 'returns unprocessable entity status' do
        make_request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        make_request
        expect(json_response['errors']).to eq(['Product must exist'])
      end
    end
  end

  describe 'GET /cart' do
    let(:cart) { create(:shopping_cart) }
    let(:product) { create(:product, name: 'Test Product', price: 10.0) }

    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    before do
      session_double = { cart_id: cart.id }
      def session_double.loaded?
        true
      end

      def session_double.enabled?
        true
      end

      allow_any_instance_of(ActionDispatch::Request)
        .to receive(:session)
        .and_return(session_double)
    end

    subject(:make_request) { get '/cart', as: :json }

    it 'returns success status' do
      make_request
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE /cart/:product_id' do
    let(:cart) { create(:shopping_cart) }
    let(:product) { create(:product, name: 'Test Product', price: 10.0) }

    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    before do
      session_double = { cart_id: cart.id }
      def session_double.loaded?
        true
      end

      def session_double.enabled?
        true
      end

      allow_any_instance_of(ActionDispatch::Request)
        .to receive(:session)
        .and_return(session_double)
    end

    subject(:make_request) { delete "/cart/#{product.id}", as: :json }

    it 'returns success status' do
      make_request
      expect(response).to have_http_status(:success)
    end

    it 'deletes item from cart' do
      expect { make_request }.to change { cart.cart_items.count }.by(-1)
    end
  end

  private

  def json_response
    @json_response ||= JSON.parse(response.body)
  end
end
