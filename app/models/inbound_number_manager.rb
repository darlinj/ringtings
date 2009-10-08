class InboundNumberManager < ActiveRecord::Base
  belongs_to :callplan
  def self.get_free_number 
    number = find_by_callplan_id(nil)
    raise Exceptions::OutOfCapacityError unless number
    number
  end
end
