class AddingVoicemailPasswordToInboundNumber < ActiveRecord::Migration
  def self.up
    add_column :inbound_number_managers, :voicemail_password, :string
  end

  def self.down
    remove_column :inbound_number_managers, :voicemail_password
  end
end
