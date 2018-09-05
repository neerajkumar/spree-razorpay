Spree::Core::Engine.add_routes do
	resources :razorpay, only: [:index, :create]
end
