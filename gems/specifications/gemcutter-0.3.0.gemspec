# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gemcutter}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nick Quaranto"]
  s.date = %q{2010-01-05}
  s.description = %q{Adds several commands to RubyGems for managing gems and more on Gemcutter.org.}
  s.email = %q{nick@quaran.to}
  s.files = ["MIT-LICENSE", "Rakefile", "lib/commands/abstract_command.rb", "lib/commands/migrate.rb", "lib/commands/owner.rb", "lib/commands/push.rb", "lib/commands/tumble.rb", "lib/commands/webhook.rb", "lib/rubygems_plugin.rb", "test/abstract_command_test.rb", "test/command_helper.rb", "test/push_command_test.rb", "test/webhook_command_test.rb"]
  s.homepage = %q{http://gemcutter.org}
  s.post_install_message = %q{
========================================================================

           Thanks for installing Gemcutter! You can now run:

    gem push          publish your gems for the world to use and enjoy
    gem owner         allow/disallow others to push to your gems
    gem webhook       register urls to be pinged when gems are pushed

========================================================================

}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Commands to interact with gemcutter.org}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
    else
      s.add_dependency(%q<json_pure>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
    end
  else
    s.add_dependency(%q<json_pure>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
  end
end
