class Callplan < ActiveRecord::Base
  has_one :inbound_number, :class_name => 'InboundNumberManager', :autosave =>true
  has_one :action, :autosave => true
  accepts_nested_attributes_for :action, :allow_destroy => true
  has_one :employee, :autosave => true
  belongs_to :user
  named_scope :expired_callplans, :conditions => "updated_at < '#{1.hours.ago}' and user_id is null"
  def self.create_demo target_phone_number, company_name
    callplan = Callplan.create! :company_name => company_name
    inbound_phone_number = InboundNumberManager.allocate_free_number_to_callplan(callplan)
    callplan.action = Action.create_demo inbound_phone_number.phone_number, target_phone_number, company_name
    callplan.inbound_number.ivr_menu = callplan.action.ivr_menu
    callplan.employee = Employee.create! :phone_number=> target_phone_number
    callplan.save!
    callplan
  end

  def self.expire_abandoned_callplans
    Callplan.expired_callplans.each do |cp|
      if cp.inbound_number
        cp.inbound_number.callplan_id = nil
        cp.inbound_number.save!
      end
      cp.destroy
    end
  end
end
