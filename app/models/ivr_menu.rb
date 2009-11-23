class IvrMenu < ActiveRecord::Base
  has_one :inbound_number_manager
  has_many :ivr_menu_entries
  belongs_to :action
end
