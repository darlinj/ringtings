class InboundNumberManager < ActiveRecord::Base
  def self.get_free_number call_plan
    number = find_by_callplan_id(nil)

    number.callplan_id = call_plan.id
    number.save!
  end
end
