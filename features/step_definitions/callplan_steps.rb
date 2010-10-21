Given %r/^we create a Callplan with these variables:$/ do |table|
  args = {}
  table.hashes.each do |hash|
    args[hash['name']] = hash['value']
  end
  @callplan = Factory :callplan, :company_name => "Di Bread the baker", :user => User.find_by_email(@current_user)
  Factory :inbound_number_manager,
    :phone_number => args['inbound_phone_number'],
    :voicemail_password => args['voicemail_password'],
    :callplan_id => @callplan.id
  action = Factory :action,
    :application_name => args['Action_type'],
    :application_data => args['Action_params'],
    :callplan_id => @callplan.id
  feature_vars['callplan_id'] = @callplan.id
  feature_vars['action_id'] = action.id
end

Given %r/^we create a standard Callplan$/ do 
    steps %q{ And we create a Callplan with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
      | voicemail_password     | secret                        |
    }
end

Given %r/^the callplan is owned by "([^\"]*)"$/ do |email|
  @callplan.user = User.find_by_email(email)
  @callplan.save
end

Given %r/^we have an IVR Menu with:$/ do |table|
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
    :type => args['ivr_menu_entry1_type'],
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

Given %r/^we set the modified date for callplan to 2 hours ago$/ do
  callplan = Callplan.find(feature_vars['callplan_id'])
  Callplan.record_timestamps = false
  callplan.updated_at = 2.hours.ago
  callplan.save
  Callplan.record_timestamps = true
end

When %r/^we run the expire callplans function$/ do
  Callplan.expire_abandoned_callplans
end

Then %r/^the callplan should be gone$/ do
  lambda {Callplan.find(feature_vars['callplan_id'])}.should raise_error
end

Given %r/^we store the inbound number$/ do
  feature_vars['inbound_number'] = Callplan.find(feature_vars['callplan_id']).inbound_number
end

Then %r/^the inbound number is freed up$/ do
  InboundNumberManager.find(feature_vars['inbound_number'].id).callplan_id.should be_nil
end

Then %r/^I visit the callplans page$/ do
  visit demo_callplan_path(feature_vars['callplan_id'])
end

Given %r/^we create a demo callplan$/ do
  InboundNumberManager.all.each do |inbound_number|
    inbound_number.callplan_id = nil
    inbound_number.ivr_menu_id = nil
    inbound_number.save!
  end
  When %{I go to the try it now page}
  And %{I fill in "Company name" with "Fooey"}
  And %{I fill in "Phone number" with "01234567890"}
  And %{I submit the form}
end

When %r/^I click the delete button for the first ivr menu entry$/ do
  click_link("delete_IVR_menu_entry_#{@callplan.action.ivr_menu.ivr_menu_entries.first.id.to_s}")
end

When %r/^I click the change button for the first ivr menu entry$/ do
  click_link("change_audio_file_#{@callplan.action.ivr_menu.ivr_menu_entries.first.id.to_s}")
end

When %r/^I click the upload file button$/ do
  click_button("upload_button")
end

When %r/^I set the digits to the same number$/ do
  steps %Q{
    And I select "1" from "callplan_action_attributes_ivr_menu_attributes_ivr_menu_entries_attributes_1_digits"
  }
end

When %r/^I have a standard callplan$/ do
  steps %Q{
    Given we create a Callplan with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
    And we have an IVR Menu with:
      | name                   | value                         |
      | long_greeting          | some long greeting            |
      | ivr_menu_entry1_digit  | 1                             |
      | ivr_menu_entry1_type   | SyntheticVoiceMenuEntry       |
      | ivr_menu_entry1_action | hello peeps                   |
      | ivr_menu_entry2_digit  | 2                             |
      | ivr_menu_entry2_type   | TransferCallMenuEntry         |
      | ivr_menu_entry2_action | 1234567890                    |
  }
end

Then %r/^I will see the correct callplan details$/ do
  steps %Q{
    And I should see "Incoming calls to: 0192837465"
    And I should see "some long greeting"
    And I should see "1"
    And I should see "Synthetic voice says:"
    And I should see "hello peeps"
    And I should see "2"
    And I should see "Transfer call to:"
    And I should see "1234567890"
  }
end
