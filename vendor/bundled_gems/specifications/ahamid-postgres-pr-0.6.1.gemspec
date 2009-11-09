# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ahamid-postgres-pr}
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Neumann"]
  s.date = %q{2009-10-15}
  s.email = %q{mneumann@ntecs.de}
  s.files = ["lib/binary_reader.rb", "lib/binary_writer.rb", "lib/buffer.rb", "lib/byteorder.rb", "lib/postgres-pr/connection.rb", "lib/postgres-pr/message.rb", "lib/postgres-pr/postgres-compat.rb", "lib/postgres-pr/typeconv/array.rb", "lib/postgres-pr/typeconv/bytea.rb", "lib/postgres-pr/typeconv/conv.rb", "lib/postgres-pr/typeconv/TC_conv.rb", "lib/postgres-pr/version.rb", "lib/postgres.rb", "test/TC_message.rb", "examples/client.rb", "examples/og/test.rb", "examples/server.rb", "examples/test_connection.rb"]
  s.homepage = %q{http://github.com/ahamid/postgres-pr}
  s.require_paths = ["lib"]
  s.requirements = ["PostgreSQL >= 7.4"]
  s.rubyforge_project = %q{postgres-pr}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A pure Ruby interface to the PostgreSQL (>= 7.4) database}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
