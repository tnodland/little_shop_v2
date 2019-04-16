
require 'rails_helper'

RSpec.describe User, type: :model do
  before :each, big_setup: true do
    @user = create(:user)
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @merchant3 = create(:merchant)
    @im = create(:inactive_merchant)
    @admin = create(:admin)

    @merchant = create(:merchant)
    @items = create_list(:item, 10,  user: @merchant, quantity: 200)

    @user_wash = create(:user, name:"user_wash", state:"Washington", city:"Seattle")
    @user_2 = create(:user, name: "user_oregon", state:"Oregon")
    @utah_user = create(:user, name: "user_utah", state:"Utah", city: "nothere")

    @top_orders_user = create(:user, name:"top_orders_user", state:"Utah")
    @many_orders = create_list(:shipped_order, 50, user:@top_orders_user)
    @many_orders.each do |order|
      create(:fulfilled_order_item, ordered_price: 5.0, item:@items[1], quantity:10, order:order)
    end

    @top_items_user = create(:user, name: "top_items_user")
    @big_order = create(:shipped_order, user: @top_items_user)
    create(:fulfilled_order_item, ordered_price: 1.0, item:@items[0], quantity:1463, order:@big_order)

    @shipped_orders_utah = create_list(:shipped_order,2, user: @utah_user)
    create(:fulfilled_order_item, ordered_price: 0.1, quantity: 10, item:@items[9], order:@shipped_orders_utah[0])
    create(:fulfilled_order_item, ordered_price: 0.1, quantity: 10, item:@items[9], order:@shipped_orders_utah[1])

    @shipped_orders_user_wash = create_list(:shipped_order,4, user: @user_wash)
    create(:fulfilled_order_item, ordered_price: 2.0, quantity: 4, item:@items[2], order:@shipped_orders_user_wash[0])
    create(:fulfilled_order_item, ordered_price: 2.0, quantity: 3, item:@items[3], order:@shipped_orders_user_wash[1])
    create(:fulfilled_order_item, ordered_price: 2.0, quantity: 9, item:@items[9], order:@shipped_orders_user_wash[2])
    create(:fulfilled_order_item, ordered_price: 2.0, quantity: 1, item:@items[8], order:@shipped_orders_user_wash[3])

    @order_1 = create(:order, user: @user_wash)
    @order_2 = create(:order, user: @user_2)
    create(:fulfilled_order_item, item:@items[0], order:@order_1)
    create(:fulfilled_order_item, item:@items[0], order:@order_2)
    create(:fulfilled_order_item, item:@items[1], order:@order_2)
  end

  context 'instance_methods' do
    it '.percent_sold_data_for_graphic', :big_setup do
      expected = [{'label'=> 'Sold', 'value' => @merchant.pct_sold},
                  {'label'=> 'Unsold', 'value' => (100- @merchant.pct_sold)}]
      actual = @merchant.percent_sold_data_for_graphic

      expect(actual).to eq(expected)

      other_merchant = create(:merchant)
      user = create(:user)
      other_item = create(:item, user:other_merchant, quantity:4)
      create(:order_item, item:other_item, quantity:6)

      expected = [{'label'=> 'Sold', 'value' => other_merchant.pct_sold},
                  {'label'=> 'Unsold', 'value' => (100- other_merchant.pct_sold)}]
      actual = other_merchant.percent_sold_data_for_graphic

      expect(actual).to eq(expected)
    end

    it '.top_states_for_graphic', big_setup: true do
      expected = [{'label'=>"Utah", 'value'=>52},
                  {'label'=>"Washington", 'value'=>4},
                  {'label'=>"Colorado", 'value'=>1},
                  {'label'=>"Other", 'value' => 0}]

      actual = @merchant.top_states_for_graphic

      expect(actual).to eq(expected)
    end

    it '.top_cities_for_graphic', big_setup: true do
      expected = [{'label'=> "Testville, Utah", 'value'=>50},
                  {'label'=> "Seattle, Washington", 'value'=>4},
                  {'label'=> "nothere, Utah", 'value'=>2},
                  {'label'=>"Other", 'value' => 1}]
      actual = @merchant.top_cities_for_graphic

      expect(actual).to eq(expected)
    end

    it '.revenue_by_month_for_graphic' do
      merchant = create(:merchant)
      item = create(:item, user:merchant)
      expected = []
      26.times do |months|
        time = months.month.ago
        shipped_orders = create_list(:shipped_order,2, created_at:time, updated_at:time)
        not_shipped_order = create(:order, created_at:time, updated_at:time)
        create(:fulfilled_order_item, order: shipped_orders[0], item:item, quantity:months+1, ordered_price: 1.0, created_at:time, updated_at:time)
        create(:fulfilled_order_item, order: shipped_orders[1], item:item, quantity:months+1, ordered_price: 1.0, created_at:time+2.days, updated_at:time+2.days)
        create(:fulfilled_order_item, order: not_shipped_order, item:item, quantity:months+1, ordered_price: 1.0, created_at:time-2.days, updated_at:time-2.days)

        if months <13
          expected << {'date' => Date.new(time.year, time.month), 'revenue' =>(months+1)*2}
        end
      end
      expected.reverse!
      actual = merchant.revenue_by_month_for_graphic
      expect(actual).to eq(expected)
    end

    it '.graphics_data', big_setup:true do
      expected = {
                    'percent-sold'=> @merchant.percent_sold_data_for_graphic,
                    'top-states' => @merchant.top_states_for_graphic,
                    'top-cities' => @merchant.top_cities_for_graphic,
                    'revenue' => @merchant.revenue_by_month_for_graphic
                }
      actual =  @merchant.graphics_data

      expect(actual).to eq(expected)
    end
  end
end
