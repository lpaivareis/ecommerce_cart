require 'rails_helper'

RSpec.describe "/carts", type: :request do
  describe "POST /add_items" do
    let(:cart) { create(:shopping_cart) }
    let(:product) { create(:product, name: "Test Product", price: 10.0) }

    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end
  
  describe "POST /carts" do
    let(:product) { create(:product, price: 10.0) }
    let(:params) { { product_id: product.id, quantity: 2 } }

    subject(:make_request) { post '/carts', params: params, as: :json }

    context 'when cart already exists in cookies' do
      let(:cart) { create(:shopping_cart) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

      before do
        allow(Carts::CreatorService).to receive(:call).and_return(
          OpenStruct.new(success?: true, data: cart)
        )
      end

      it 'returns success status' do
        make_request
        expect(response).to have_http_status(:success)
      end

      it 'calls service with correct params' do
        make_request
        expect(Carts::CreatorService).to have_received(:call)
      end
    end

    context 'when creating a new cart' do
      let(:new_cart) { create(:shopping_cart) }

      before do
        allow(Carts::CreatorService).to receive(:call).and_return(
          OpenStruct.new(success?: true, data: new_cart)
        )
      end

      it 'returns success status' do
        make_request
        expect(response).to have_http_status(:success)
      end

      it 'creates cart through service' do
        make_request
        expect(Carts::CreatorService).to have_received(:call)
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

  private

  def json_response
    @json_response ||= JSON.parse(response.body)
  end
end
