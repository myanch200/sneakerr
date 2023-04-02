class User < ApplicationRecord
  include Clearance::User
  has_one :cart
  after_create :create_cart


  private

  def create_cart
    self.cart = Cart.create!(user_id: self .id)
  end
end
