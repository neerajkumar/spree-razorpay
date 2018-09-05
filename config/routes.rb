Spree::Core::Engine.add_routes do
  resources :razorpay, only: :create
end
