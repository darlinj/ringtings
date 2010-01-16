class Callplan < ActiveRecord::Base
  has_one :inbound_number, :class_name => 'InboundNumberManager', :autosave =>true
  has_one :action, :autosave => true
  accepts_nested_attributes_for :action
  has_one :employee, :autosave => true
  belongs_to :user
end
