module Spree
  class RazorpayController < StoreController

    skip_before_action :verify_authenticity_token

    def create
      response_status = Spree::Order.process_razorpayment(params, current_order)
      @order = current_order
      if response_status == 'captured'
        @order.next!
        @message = Spree.t(:order_processed_successfully)
        @current_order = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true
        @error = false
        @redirect_path = order_path(@order)
      else
        @order.update_attributes(payment_state: 'failed')
        @error = true
        @message = 'There was an error processing your payment'
        @redirect_path = checkout_state_path(@order.state)
      end
    end
  end
end
