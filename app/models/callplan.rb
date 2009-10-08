class Callplan < ActiveRecord::Base
  has_one :inbound_number, :class_name => 'InboundNumberManager'
  def self.generate params
    cp = create :company_name => params["company_name"]
    cp.inbound_number = InboundNumberManager.get_free_number
    cp.save!
    cp
  end
end
