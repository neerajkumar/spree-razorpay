require 'spec_helper'

describe Spree::Order, :vcr do

  let(:gateway) { create(:razorpay_gateway) }

  let(:params) do
    {
      payment_method_id: gateway.id,
      razorpay_payment_id: 'pay_12345abcdeFGHI'
    }
  end

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

  let(:order) { OrderWalkthrough.up_to(:payment) }

  describe '.amount_in_paise' do
    subject { order.amount_in_paise }

    it 'returns amount in paise' do
      expect(subject).to_not be_nil
      amount_in_paise = (order.amount.to_f * 100).to_i
      expect(subject).to eq(amount_in_paise)
    end
  end

  describe '.process_razorpayment' do
    subject { Spree::Order.process_razorpayment(params, order) }

    context 'when payment is successful' do
      before do
        Razorpay::Payment = Struct.new(:id, :entity, :amount, :currency, :status, :international, :method, :amount_refunded, :captured, :card_id, :bank, :wallet, :vpa, :email, :contact)
        razorpay_payment_1 = new_razorpay_payment(attributes)
        attributes[:status] = 'captured'
        razorpay_payment_2 = new_razorpay_payment(attributes)
        allow_any_instance_of(Razorpay::Payment).to receive(:capture).and_return(new_razorpay_payment(attributes))
        allow(Razorpay::Payment).to receive(:fetch).twice.and_return(razorpay_payment_1, razorpay_payment_2)
      end

      it 'makes the payment and returns status' do
        expect { subject }.to change(Spree::Payment, :count).by(1)
        expect(Spree::RazorpayCheckout.count).to eq(1)
        expect(Spree::RazorpayCheckout.last.status).to eq('authorized')
        expect(subject).to eq('captured')
        expect(order.payments.last.response_code).to eq('captured')
      end
    end

    context 'when payment is not successful' do
      before do
        Razorpay::Payment = Struct.new(:id, :entity, :amount, :currency, :status, :international, :method, :amount_refunded, :captured, :card_id, :bank, :wallet, :vpa, :email, :contact)
        attributes[:status] = 'declined'
        allow(Razorpay::Payment).to receive(:fetch).and_return(new_razorpay_payment(attributes))
      end

      it 'raises Standard Error' do
        expect { subject }.to raise_error(StandardError)
      end
    end
  end

  private

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
