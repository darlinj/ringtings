class Callplan < ActiveRecord::Base
  def self.create! params
    cp = create params
    cp.inbound_number = InboundNumberManager.get_free_number
    cp.save!
    cp
  end
end
