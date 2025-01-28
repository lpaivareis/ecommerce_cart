FactoryBot.define do
  factory :shopping_cart, class: 'Cart' do
    total_price { 10.00 }
  end
end