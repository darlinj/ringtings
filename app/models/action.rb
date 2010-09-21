class Action < ActiveRecord::Base
  belongs_to :callplan
  has_one :ivr_menu, :autosave => true
  accepts_nested_attributes_for :ivr_menu, :allow_destroy => true

  def self.create_demo inbound_number, target_number, company_name
    ivr_menu = IvrMenu.create_demo company_name,
      inbound_number,
      target_number
    Action.create :application_name => "ivr",
      :application_data => "ivr_menu_#{inbound_number}",
      :ivr_menu => ivr_menu
  end
end
