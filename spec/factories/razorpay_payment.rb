FactoryBot.define do
  factory :razorpay_payment, class: Spree::PaymentMethod do
    type { 'Spree::Gateway::RazorpayGateway' }
    name { 'Razorpay (For Wallet, Netbanking, Credit Card and UPI)' }
    description { 'Razorpay Payment Gateway' }
    active { true }
    before(:create) do |payment|
      payment.preferences[:key_id] = 'rzp_test_12345abcdeFGHI'
      payment.preferences[:key_secret] = 'ABCDEFGH12345678ijklmnop'
      payment.preferences[:merchant_name] = FFaker::Company.name
      payment.preferences[:merchant_description] = FFaker::AWS.product_description
      payment.preferences[:merchant_address] = FFaker::Address.city
      payment.preferences[:theme_color] = '#F37254'
      payment.preferences[:server] = 'test'
      payment.preferences[:test_mode] = true
    end
  end
end
