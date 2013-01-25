class Facebook::PaymentPlacement

  attr_reader :content

  def initialize(content)
    @content = content
  end

  def self.from_request(request, &block)
    credits = request['credits']
    item = JSON.parse(credits['order_info'])    
    content = yield item['item_id'].to_i if block_given?
    new content
  end

  def to_json
    {
        content:[content], 
        method:'payments_get_items' 
    }
  end
end
