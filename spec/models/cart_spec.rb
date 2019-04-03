require 'rails_helper'

RSpec.describe Cart do
  it "#total_count calcualtes total number of items" do
    cart = Cart.new({"5"=> 3, "3" => 4})
    expect(cart.total_count).to eq(7)
  end

end
