class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || Hash.new(0)
  end

  def add_item(item_id)
    @contents[item_id] +=1
  end
end
