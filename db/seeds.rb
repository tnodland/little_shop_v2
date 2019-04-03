require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

user = create(:user)
merchant = create(:merchant)
admin = create(:admin)
iu = create(:inactive_user)
im = create(:inactive_merchant)

item1 = create(:item, user: merchant)
item2 = create(:item, user: merchant)
item3 = create(:inactive_item, user: merchant)

order = create(:order, user: user)

oi = create(:order_item, item: item1, order: order)
oi2 = create(:fulfilled_order_item, item: item1, order: order)

# binding.pry
