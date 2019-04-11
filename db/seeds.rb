require 'factory_bot_rails'

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

@time_rng = Random.new(104771926725897930682341174863059830501)
def rand_time(from: 0.0, to: Time.now)
  Time.at(@time_rng.rand(from..to))
end

a_1 = User.create(role: 'admin',    enabled: true,  name: "Jane Siteowner", street_address: "123 Sorich Drive",       city: "Winning",          state: "OK", zip_code: "12345", email: "admin1@example.com",    password: "supersecure",  created_at: rand_time(from: 7.years.ago, to: 6.years.ago))
a_2 = User.create(role: 'admin',    enabled: true,  name: "Jack Siteowner", street_address: "123 Sorich Drive",       city: "Winning",          state: "OK", zip_code: "12345", email: "admin2@example.com",    password: "supersecure",  created_at: rand_time(from: 7.years.ago, to: 6.years.ago))
m_1 = User.create(role: 'merchant', enabled: true,  name: "Valerie Vendor", street_address: "257 Pine Street",        city: "Fairfax",          state: "VT", zip_code: "05454", email: "merchant1@example.com", password: "mostlysecure", created_at: rand_time(from: 6.years.ago, to: 5.years.ago))
m_2 = User.create(role: 'merchant', enabled: true,  name: "Miles Merchant", street_address: "3521 Hardline Road",     city: "Salinas",          state: "CA", zip_code: "93907", email: "merchant2@example.com", password: "mostlysecure", created_at: rand_time(from: 6.years.ago, to: 5.years.ago))
u_1 = User.create(role: 'user',     enabled: true,  name: "Robert Morgan",  street_address: "2817 Norman Street",     city: "Los Angeles",      state: "CA", zip_code: "90015", email: "user1@example.com",     password: "password",     created_at: rand_time(from: 5.years.ago, to: 4.years.ago))
u_2 = User.create(role: 'user',     enabled: true,  name: "Shari Gable",    street_address: "2207 Euclid Avenue",     city: "Colorado Springs", state: "CO", zip_code: "80903", email: "user2@example.com",     password: "password",     created_at: rand_time(from: 5.years.ago, to: 4.years.ago))
u_3 = User.create(role: 'user',     enabled: true,  name: "Edward Lehmann", street_address: "356 Coulter Lane",       city: "Richmond",         state: "VA", zip_code: "23260", email: "user3@example.com",     password: "password",     created_at: rand_time(from: 5.years.ago, to: 4.years.ago))
m_3 = User.create(role: 'merchant', enabled: false, name: "Sally Sellers",  street_address: "3868 Geneva Street",     city: "Fresno",           state: "CA", zip_code: "93714", email: "merchant3@example.com", password: "mostlysecure", created_at: rand_time(from: 4.years.ago, to: 3.years.ago))
u_4 = User.create(role: 'user',     enabled: true,  name: "Robert Douglas", street_address: "1327 Sussex Court",      city: "Bellmar",          state: "NJ", zip_code: "08099", email: "user4@example.com",     password: "password",     created_at: rand_time(from: 4.years.ago, to: 3.years.ago))
u_5 = User.create(role: 'user',     enabled: false, name: "Vickie Brown",   street_address: "3369 Freed Drive",       city: "Turlock",          state: "CA", zip_code: "95380", email: "user5@example.com",     password: "password",     created_at: rand_time(from: 4.years.ago, to: 3.years.ago))
m_4 = User.create(role: 'merchant', enabled: true,  name: "Ben Busker",     street_address: "699 Cemetery Street",    city: "Clarksburg",       state: "WV", zip_code: "26302", email: "merchant4@example.com", password: "mostlysecure", created_at: rand_time(from: 3.years.ago, to: 2.years.ago))
u_6 = User.create(role: 'user',     enabled: true,  name: "Isiah James",    street_address: "1087 Washington Street", city: "Corpus Christi",   state: "TX", zip_code: "78476", email: "user6@example.com",     password: "password",     created_at: rand_time(from: 3.years.ago, to: 2.years.ago))
m_5 = User.create(role: 'merchant', enabled: false, name: "Tina Tycoon",    street_address: "2890 Center Street",     city: "Havelock",         state: "NC", zip_code: "28532", email: "merchant5@example.com", password: "mostlysecure", created_at: rand_time(from: 3.years.ago, to: 2.years.ago))

merchants = [m_1, m_2, m_3, m_4, m_5]
users = [u_1, u_2, u_3, u_4, u_5, u_6]

descriptors = {"Basic"  => 1.0,
               "Fancy"  => 1.8,
               "Royal"  => 3.0,
               "Wooden" => 0.8,
               "Stone"  => 1.1,
               "Iron"   => 1.3,
               "Bronze" => 1.6,
               "Gold"   => 2.2}

products = {"Table"      => 100,
            "Chair"      => 30,
            "Floor Lamp" => 20,
            "Couch"      => 85,
            "Sideboard"  => 40,
            "Bed"        => 300,
            "Ottoman"    => 15,
            "Desk"       => 50}

description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Facilisis sed odio morbi quis commodo odio aenean sed. Nunc mattis enim ut tellus elementum. Aenean sed adipiscing diam donec adipiscing tristique risus nec. Mauris vitae ultricies leo integer malesuada nunc vel. At quis risus sed vulputate odio ut enim blandit volutpat. Leo a diam sollicitudin tempor id eu nisl nunc mi. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Quis varius quam quisque id diam. Sit amet aliquam id diam maecenas ultricies. Lacus viverra vitae congue eu consequat ac. Pulvinar pellentesque habitant morbi tristique senectus et netus et. Ut tortor pretium viverra suspendisse potenti nullam ac tortor vitae. Auctor neque vitae tempus quam. In iaculis nunc sed augue. Ultricies leo integer malesuada nunc vel risus commodo viverra maecenas. Posuere lorem ipsum dolor sit amet. Ullamcorper malesuada proin libero nunc consequat interdum varius sit. Quis commodo odio aenean sed adipiscing diam donec adipiscing tristique.

Ut diam quam nulla porttitor massa id neque. Condimentum lacinia quis vel eros donec ac odio tempor orci. Sem viverra aliquet eget sit amet tellus cras adipiscing enim. Semper auctor neque vitae tempus quam pellentesque nec nam aliquam. Laoreet sit amet cursus sit amet dictum sit. Vitae auctor eu augue ut. Ut consequat semper viverra nam libero justo laoreet sit amet. Egestas congue quisque egestas diam in arcu. Fames ac turpis egestas integer eget aliquet nibh praesent. Praesent semper feugiat nibh sed. Felis eget nunc lobortis mattis aliquam faucibus. Mauris rhoncus aenean vel elit scelerisque. Velit scelerisque in dictum non consectetur a. Ornare lectus sit amet est placerat in egestas erat imperdiet."

items = []
rng = Random.new(233911598050075205791144242652162091523) #ensure everyone's seed data is the same
products.each do |item, base_price|
  descriptors.each do |prefix, price_scale|
    items << Item.create(name: "#{prefix} #{item}",
                         description: description,
                         current_price: base_price * price_scale,
                         quantity: rng.rand(5..80),
                         enabled: (rng.rand(1..100) > 85 ? false : true),
                         image_url: "https://imgplaceholder.com/500x500?text=#{prefix}+#{item}",
                         merchant_id: merchants.sample(random: rng).id,
                         created_at: rand_time(from: 2.years.ago, to: 1.year.ago))
  end
end

(1..42).each do |i|
  order_user = users.sample(random: rng)
  cart = {}
  # add 1-8 items to the cart
  (1..(rng.rand(0..8))).each do |j|
    # select an itemID at random from all the possible permutations of
    # descriptors and products, which is flexible in case we decide to add more
    # data later
    item_id = rng.rand(1..(descriptors.length * products.length)).to_s
    quantity = rng.rand(1..4)
    # if rng selects the same item twice, it'll just override the quantity,
    # which is fine for this situation
    cart[item_id] = quantity
  end
  order = Order.from_cart(order_user, cart)
  created_at = rand_time(from: 1.year.ago, to: 1.week.ago)
  @updated_at = rand_time(from: created_at)
  # this will generate an even distribution or order statuses, which isn't
  # entirely realistic, but doing 42 orders gives us some breathing room
  status = rng.rand(0..3)
  if status == 1 || status == 2
    # all items for packaged and shipped orders should be fulfulled
    order.order_items.each do |item|
      updated = rand_time(from: created_at)
      @updated_at = updated if updated > @updated_at
      item.update(fulfilled: true, created_at: created_at, updated_at: updated)
    end
  elsif status == 0
    # some items for pending orders should be in fulfilled status, some should not
    order.order_items.each do |item|
      updated = rand_time(from: created_at)
      @updated_at = updated if updated > @updated_at
      item.update(fulfilled: true, created_at: created_at, updated_at: updated) if rng.rand(0..1) == 1
    end
  end
  order.update(status: status, created_at: created_at, updated_at: @updated_at)
end
