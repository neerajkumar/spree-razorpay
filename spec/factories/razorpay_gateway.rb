FactoryBot.define do
  factory :razorpay_gateway, class: Spree::Gateway::RazorpayGateway do
    name { 'Spree::Gateway::RazorpayGateway' }
  end
end
