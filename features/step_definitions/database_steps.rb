Given /^and "([^\"]*)" is stored in the "([^\"]*)" table in the database$/ do |value, table|
  Factory table.to_sym, :phone_number=>value, :callplan_id=>nil
end

