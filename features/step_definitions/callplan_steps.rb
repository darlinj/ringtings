Given /^we create a Callplan \(and store it's ID as <([^\)]*)>\) with these variables:$/ do |callplan_id, table|
  args = {}
  table.hashes.each do |hash|
    args[hash['name']] = hash['value']
  end
  callplan = Factory :callplan, :company_name => "Di Bread the baker"
  Factory :inbound_number_manager,
    :phone_number => args['inbound_phone_number'],
    :callplan_id => callplan.id
  action = Factory :action,
    :application_name => args['Action_type'],
    :application_data => args['Action_params'],
    :callplan_id => callplan.id
  feature_vars['callplan_id'] = callplan.id
  feature_vars['action_id'] = action.id
end

Given /^we have an IVR Menu with:$/ do |table|
  args = {}
  table.hashes.each do |hash|
    args[hash['name']] = hash['value']
  end

  ivr_menu = Factory :ivr_menu,
    :long_greeting => args['long_greeting'],
    :action_id => feature_vars['action_id']
  Factory :ivr_menu_entry,
    :digits => args['ivr_menu_entry1_digit'],
    :param_1 => args['ivr_menu_entry1_action'],
    :ivr_menu_id => ivr_menu.id,
    :prototype => IvrMenuEntryPrototype.find_by_name(args['ivr_menu_entry1_type'])
  if args['ivr_menu_entry2_action']
    Factory :ivr_menu_entry,
      :digits => args['ivr_menu_entry2_digit'],
      :param_1 => args['ivr_menu_entry2_action'],
      :ivr_menu_id => ivr_menu.id,
      :prototype => IvrMenuEntryPrototype.find_by_name(args['ivr_menu_entry2_type'])
  end
end

Given /^we set the modified date for callplan to 2 hours ago$/ do
  callplan = Callplan.find(feature_vars['callplan_id'])
  Callplan.record_timestamps = false
  callplan.updated_at = 2.hours.ago
  callplan.save
  Callplan.record_timestamps = true
end

When /^we run the expire callplans function$/ do
  Callplan.expire_abandoned_callplans
end

Then /^the callplan should be gone$/ do
  lambda {Callplan.find(feature_vars['callplan_id'])}.should raise_error
end

Given /^we store the inbound number$/ do
  feature_vars['inbound_number'] = Callplan.find(feature_vars['callplan_id']).inbound_number
end

Then /^the inbound number is freed up$/ do
  InboundNumberManager.find(feature_vars['inbound_number'].id).callplan_id.should be_nil
end

Then /^I visit the callplans page$/ do
  visit demo_callplan_path(feature_vars['callplan_id'])
end

Given /^we create a demo callplan$/ do
  When %{I go to the try it now page}
  And %{I fill in "Company name" with "Fooey"}
  And %{I fill in "Phone number" with "012345678"}
  And %{I submit the form}
end

