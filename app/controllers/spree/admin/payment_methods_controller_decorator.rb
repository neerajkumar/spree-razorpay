Spree::Admin::PaymentMethodsController.class_eval do

  after_action :setup_razorpay, only: :update

  private

  def setup_razorpay
    Razorpay.setup(params[:gateway_razorpay_gateway][:preferred_key_id], params[:gateway_razorpay_gateway][:preferred_key_secret])
  end
end
