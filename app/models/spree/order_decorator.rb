Spree::Order.class_eval do

  def self.process_razorpayment(params)
    product = Spree::Product.find(params[:product_id])
    razorpay_pmnt_obj = Razorpay::Payment.fetch(params[:razorpay_payment_id])
    status = razorpay_pmnt_obj.status
    if status == "authorized"
      razorpay_pmnt_obj.capture({amount: product.price_in_paise})
      razorpay_pmnt_obj = Razorpay::Payment.fetch(params[:razorpay_payment_id])
      params.merge!({state: razorpay_pmnt_obj.status, item_total: product.price_in_paise})
      current_order || Spree::Order.create(params)
    else
      raise StandardError, "UNable to capture payment"
    end
  end
end
