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
    :user_param_part => args['ivr_menu_entry1_action'], 
    :prompt => args['ivr_menu_entry1_prompt'],
    :ivr_menu_id => ivr_menu.id
  Factory :ivr_menu_entry, 
    :digits => args['ivr_menu_entry2_digit'],
    :user_param_part => args['ivr_menu_entry2_action'], 
    :prompt => args['ivr_menu_entry2_prompt'],
    :ivr_menu_id => ivr_menu.id
end

Given /^we store the Callplan ID as <callplan_id>$/ do
  pending
end

