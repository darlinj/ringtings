class AddInboundNumberData < ActiveRecord::Migration
  def self.up
    puts ENV['RAILS_ENV']
    if ENV['RAILS_ENV'] == "production"
      (1..1000).each do | number |
        InboundNumberManager.create! :phone_number => "0#{123456000+number}"
      end
    end
  end

  def self.down
  end
end
