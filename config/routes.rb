Spree::Core::Engine.add_routes do
  post '/purchase', to: 'razorpay#purchase_status', as: :razorpay_purchase
end
