class InboundNumberManager < ActiveRecord::Base
  belongs_to :callplan
  belongs_to :ivr_menu
  def self.allocate_free_number_to_callplan callplan
    number = find_by_callplan_id(nil)
    RAILS_DEFAULT_LOGGER.error( "number = #{number}")
    raise Exceptions::OutOfCapacityError unless number
    number.callplan_id = callplan.id
    number.save!
    number
  end
end
