When /^I click the delete button for the first ivr menu entry$/ do
  When %{I click the link with class: "delete_IVR_menu_entry"}
end


And /^I click the "Add a menu option" image button$/ do
  When %{I click the link with class: "add_IVR_menu_entry"}
end
