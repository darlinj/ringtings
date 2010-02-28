When /^I click the upload file button$/ do
  $browser.button(:id, "upload_button").click
end

When /^I click the change button for the first ivr menu entry$/ do
  When %{I click the link with class: "change_audio_file"}
end

When /^I click the delete button for the first ivr menu entry$/ do
  When %{I click the link with class: "delete_IVR_menu_entry"}
end


And /^I click the "Add a menu option" image button$/ do
  When %{I click the link with class: "add_IVR_menu_entry"}
end
