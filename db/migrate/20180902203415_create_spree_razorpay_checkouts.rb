class CreateSpreeRazorpayCheckouts < ActiveRecord::Migration
  def change
    create_table :spree_razorpay_checkouts do |t|
      t.string :order_id
    end
  end
end
