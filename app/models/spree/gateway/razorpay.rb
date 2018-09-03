module Spree
  class Gateway::Razorpay < Gateway
    preference :key_id, :string
    preference :key_secret, :string

    def supports?(source)
      true
    end

    def provider_class
      self
    end

    def provider
      self
    end

    def auto_capture?
      true
    end

    def method_type
      'razorpay'
    end

    def purchase(amount, transaction_details, gateway_options={})
      ActiveMerchant::Billing::Response.new(true, 'razorpay success')
    end

    def request_type
      'DEFAULT'
    end

    
  end
end
