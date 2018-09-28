require 'spec_helper'
require 'shared/new_razorpay_payment'

describe Spree::RazorpayController, type: :controller do

  let(:razorpay_payment) { create(:razorpay_payment) }
  let!(:store) { create(:store, default: true) }

  let(:params) do
    {
      payment_method_id: razorpay_payment.id,
      razorpay_payment_id: 'pay_12345abcdeFGHI'
    }
  end

  let(:order) { OrderWalkthrough.up_to(:payment) }

  include_context 'new_razorpay_payment_spec'

  before do
    allow(controller).to receive(:current_order).and_return(order)
    allow(controller).to receive(:spree_current_user).and_return(nil)
    allow(controller).to receive(:current_store).and_return(store)
    Razorpay::Payment = Struct.new(:id, :entity, :amount, :currency, :status, :international, :method, :amount_refunded, :captured, :card_id, :bank, :wallet, :vpa, :email, :contact)
    @razorpay_payment_1 = new_razorpay_payment(attributes)
  end

  describe 'POST #create' do
    subject { post :create, params: params }

    context 'when payment is successful' do

      before do
        attributes[:status] = 'captured'
        razorpay_payment_2 = new_razorpay_payment(attributes)
        allow_any_instance_of(Razorpay::Payment).to receive(:capture).and_return(new_razorpay_payment(attributes))
        allow(Razorpay::Payment).to receive(:fetch).twice.and_return(@razorpay_payment_1, razorpay_payment_2)
      end

      it 'returns 200 status' do
        expect(subject).to have_http_status(200)
      end

      it 'assigns instance variables' do
        subject
        expect(assigns(:message)).to eq(Spree.t(:order_processed_successfully))
        expect(assigns(:current_order)).to be_nil
        expect(assigns(:error)).to be_falsey
        expect(assigns(:redirect_path)).to eq(order_path(order))
      end
    end

    context 'when payment is not successful' do

      before do
        attributes[:status] = 'declined'
        razorpay_payment_2 = new_razorpay_payment(attributes)
        allow_any_instance_of(Razorpay::Payment).to receive(:capture).and_return(new_razorpay_payment(attributes))
        allow(Razorpay::Payment).to receive(:fetch).twice.and_return(@razorpay_payment_1, razorpay_payment_2)
      end

      it 'returns 200 status' do
        expect(subject).to have_http_status(200)
      end

      it 'fails the processing of payment' do
        subject
        expect(assigns(:order).reload.payment_state).to eq('failed')
        expect(assigns(:error)).to be_truthy
        expect(assigns(:message)).to eq('There was an error processing your payment')
        expect(assigns(:redirect_path)).to eq(checkout_state_path(order.state))
      end
    end
  end
end
