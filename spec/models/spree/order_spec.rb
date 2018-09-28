require 'spec_helper'
require 'shared/new_razorpay_payment'

describe Spree::Order, type: :model do

  let(:razorpay_payment) { create(:razorpay_payment) }

  let(:params) do
    {
      payment_method_id: razorpay_payment.id,
      razorpay_payment_id: 'pay_12345abcdeFGHI'
    }
  end

  let(:order) { OrderWalkthrough.up_to(:payment) }

  include_context 'new_razorpay_payment_spec'

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
end
