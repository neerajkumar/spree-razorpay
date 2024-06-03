module Spree::OrderDecorator
  def self.prepended(base)
    base.extend StaticComponents
    base.private_class_method :setup_razorpay, :payment
    
  end
  
  def amount_in_paise
    (amount.to_f * 100).to_i
  end
  
  module StaticComponents
    def process_razorpayment(params, order)
      payment_method = Spree::PaymentMethod.find(params[:payment_method_id])
      setup_razorpay(payment_method)
      razorpay_pmnt_obj = Razorpay::Payment.fetch(params[:razorpay_payment_id])
      status            = razorpay_pmnt_obj.status
      payment           = payment(order, razorpay_pmnt_obj, payment_method)
      if status == "authorized"
        razorpay_pmnt_obj.capture({ amount: order.amount_in_paise })
        razorpay_pmnt_obj = Razorpay::Payment.fetch(params[:razorpay_payment_id])
        payment.update(response_code: razorpay_pmnt_obj.status)
        razorpay_pmnt_obj.status
      else
        raise StandardError, 'Unable to capture payment'
      end
    end
    
    def setup_razorpay(payment_method)
      Razorpay.setup(payment_method.preferences[:key_id], payment_method.preferences[:key_secret])
    end
    
    def payment(order, payment_object, payment_method)
      order.payments.create!(
        source:         Spree::RazorpayCheckout.create(
          order_id:            order.id,
          razorpay_payment_id: payment_object.id,
          status:              payment_object.status,
          payment_method:      payment_object.method,
          card_id:             payment_object.card_id,
          bank:                payment_object.bank,
          wallet:              payment_object.wallet,
          vpa:                 payment_object.vpa,
          email:               payment_object.email,
          contact:             payment_object.contact
        ),
        payment_method: payment_method,
        amount:         order.total,
        response_code:  payment_object.status
      )
    end
  
  end
end

Spree::Order.prepend Spree::OrderDecorator
