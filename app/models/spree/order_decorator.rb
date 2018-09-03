Spree::Order.class_eval do

  def self.process_razorpayment(params)
    razorpay_pmnt_obj = Razorpay::Payment.fetch(params[:razorpay_payment_id])
    order = current_order
    status = razorpay_pmnt_obj.status
    if status == "authorized"
      razorpay_pmnt_obj.capture({ amount: order.amount_in_paise })
      razorpay_pmnt_obj = Razorpay::Payment.fetch(params[:razorpay_payment_id])
      params.merge!({ state: razorpay_pmnt_obj.status, item_total: order.amount_in_paise })
      current_order
    else
      raise StandardError, "UNable to capture payment"
    end
  end

  def amount_in_paise
    (amount.to_f * 100).to_i
  end
end
