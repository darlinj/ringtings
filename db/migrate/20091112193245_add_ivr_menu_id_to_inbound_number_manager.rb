class AddIvrMenuIdToInboundNumberManager < ActiveRecord::Migration
  def self.up
    add_column :inbound_number_managers, :ivr_menu_id, :integer
  end

  def self.down
    remove_column :inbound_number_managers, :ivr_menu_id
  end
end
