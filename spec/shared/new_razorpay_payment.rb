require 'spec_helper'

RSpec.shared_context 'new_razorpay_payment_spec' do
  let(:attributes) do
    {
      id: 'pay_12345abcdeFGHI',
      entity: 'payment',
      amount: 1200,
      currency: 'INR',
      status: 'authorized',
      international: false,
      method: 'card',
      amount_refunded: 0,
      captured: false,
      card_id: 'card_12345abcdeFGHI',
      bank: nil,
      wallet: nil,
      vpa: nil,
      email: FFaker::Internet.email,
      contact: FFaker::PhoneNumber.phone_number
    }
  end

  protected

  def new_razorpay_payment(attributes)
    Razorpay::Payment.new(
      attributes[:id],
      attributes[:entity],
      attributes[:amount],
      attributes[:currency],
      attributes[:status],
      attributes[:international],
      attributes[:method],
      attributes[:amount_refunded],
      attributes[:captured],
      attributes[:card_id],
      attributes[:bank],
      attributes[:wallet],
      attributes[:vpa],
      attributes[:email],
      attributes[:contact]
    )
  end
end
