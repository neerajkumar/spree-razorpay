require 'razorpay'

module Spree
  class RazorpayController < StoreController

    skip_before_action :verify_authenticity_token

    def index
      @product = Spree::Product.last
    end

    def purchase_status
      payment_method = Spree::PaymentMethod.find(params[:payment_method_id])
      Razorpay.setup(payment_method.preferences[:key_id], payment_method.preferences[:key_secret])
      @order = Spree::Order.process_razorpayment(params)
      redirect_to order_path(@order)
    end
  end
end
