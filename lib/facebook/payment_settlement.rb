class Facebook::PaymentSettlement

  attr_reader :receiver_uid, :status, :order_id, :item_ids

  def initialize(receiver_uid, status, order_id, item_ids)
    @receiver_uid = receiver_uid
    @status = status
    @order_id = order_id
    @item_ids = item_ids
  end

  def self.from_request(request)
    credits = request['credits']
    status = credits['status']
    order_details = JSON.parse(credits['order_details'])
    item_ids = order_details['items'].flat_map {|item| item['item_id']}
    new(order_details['receiver'], status,  order_details['order_id'], item_ids)
  end

  def placed?
    status == 'placed'
  end

  def settled?
    status == 'settled'
  end

  def canceled?
    status == 'canceled'
  end

  def settle(&block)
    raise Exceptions::FacebookPaymentNotPlaced if !placed?
    
    yield self if block_given?
    mark_as_settled
    to_json
  end

  def cancel
    mark_as_canceled
    to_json
  end

  def to_json
    { 
      content:
        { 
          status: return_status, 
          order_id: order_id 
        }, 
      method:'payments_status_update' 
    }
  end

  protected 

  def return_status
    case status
      when 'placed'; raise Exceptions::FacebookPaymentNotSettled
      when 'settled';'settled'
      else 'canceled'
    end
  end

  def mark_as_settled
    @status = 'settled'
  end

  def mark_as_canceled
    @status = 'canceled'
  end

end