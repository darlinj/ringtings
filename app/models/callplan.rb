class Callplan < ActiveRecord::Base
  has_one :inbound_number, :class_name => 'InboundNumberManager'
  has_one :action
  has_one :employee
  belongs_to :user
end
