require 'spec_helper'

describe Spree::Gateway::RazorpayGateway, type: :model do

  let(:gateway) { create(:razorpay_gateway) }

  describe '.purchase' do
    subject { gateway.purchase(BigDecimal.new('12.00'), {}) }

    it 'returns ActiveMerchant::Billing::Response object' do
      expect(subject).to be_a(ActiveMerchant::Billing::Response)
      expect(subject).to be_success
      expect(subject.message).to eq('razorpay success')
    end
  end
end
