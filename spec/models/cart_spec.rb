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

  it "#update_quantity(item_id, quantity), updates the correct item quantity, deleting item if appropriate" do
    cart = Cart.new({"5"=> 3, "3" => 4})
    cart.update_quantity("5", 6)
    expected = {"5"=>6, "3"=>4}
    expect(cart.contents).to eq(expected)

    cart.update_quantity("3",0)
    expected = {"5"=>6}
    expect(cart.contents).to eq(expected)
  end

end
