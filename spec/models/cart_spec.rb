require 'rails_helper'

RSpec.describe Cart do
  it "#total_count calcualtes total number of items" do
    cart = Cart.new({"5"=> 3, "3" => 4})
    expect(cart.total_count).to eq(7)
  end

  it "#add_item(item_id) adds item to the contents hash" do
    cart = Cart.new({"5"=> 3, "3" => 4})
    cart.add_item("1")
    expected = {"5"=> 3, "3" => 4, "1" =>1}
    expect(cart.contents).to eq(expected)

    cart.add_item("5")
    expected = {"5"=> 4, "3" => 4, "1" =>1}
    expect(cart.contents).to eq(expected)
  end

end
