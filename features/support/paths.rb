module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the homepage/
      '/'

    when /a restricted page/
      callplan_path(1)
    when /the sign up page/i
      new_user_path
    when /the sign in page/i
      new_session_path
    when /the freeswitch interface/i
      freeswitch_index_path
    when /the try it now page/i
      demo_callplans_path
    when /the demo callplans page/i
      demo_callplan_path(1)
    when /the current callplan page/i
      callplan_path(@callplan.id)
    when /the callplan page/i
      callplan_path(1)
    when /the password reset request page/i
      new_password_path

    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
