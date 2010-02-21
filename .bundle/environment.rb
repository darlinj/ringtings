# DO NOT MODIFY THIS FILE

require 'digest/sha1'
require "rubygems"

module Bundler
  module SharedHelpers

    def default_gemfile
      gemfile = find_gemfile
      gemfile or raise GemfileNotFound, "The default Gemfile was not found"
      Pathname.new(gemfile)
    end

    def in_bundle?
      find_gemfile
    end

  private

    def find_gemfile
      return ENV['BUNDLE_GEMFILE'] if ENV['BUNDLE_GEMFILE']

      previous = nil
      current  = File.expand_path(Dir.pwd)

      until !File.directory?(current) || current == previous
        filename = File.join(current, 'Gemfile')
        return filename if File.file?(filename)
        current, previous = File.expand_path("..", current), current
      end
    end

    def clean_load_path
      # handle 1.9 where system gems are always on the load path
      if defined?(::Gem)
        me = File.expand_path("../../", __FILE__)
        $LOAD_PATH.reject! do |p|
          next if File.expand_path(p).include?(me)
          p != File.dirname(__FILE__) &&
            Gem.path.any? { |gp| p.include?(gp) }
        end
        $LOAD_PATH.uniq!
      end
    end

    def reverse_rubygems_kernel_mixin
      # Disable rubygems' gem activation system
      ::Kernel.class_eval do
        if private_method_defined?(:gem_original_require)
          alias rubygems_require require
          alias require gem_original_require
        end

        undef gem
      end
    end

    def cripple_rubygems(specs)
      reverse_rubygems_kernel_mixin

      executables = specs.map { |s| s.executables }.flatten

     :: Kernel.class_eval do
        private
        def gem(*) ; end
      end
      Gem.source_index # ensure RubyGems is fully loaded

      ::Kernel.send(:define_method, :gem) do |dep, *reqs|
        if executables.include? File.basename(caller.first.split(':').first)
          return
        end
        opts = reqs.last.is_a?(Hash) ? reqs.pop : {}

        unless dep.respond_to?(:name) && dep.respond_to?(:version_requirements)
          dep = Gem::Dependency.new(dep, reqs)
        end

        spec = specs.find  { |s| s.name == dep.name }

        if spec.nil?
          e = Gem::LoadError.new "#{dep.name} is not part of the bundle. Add it to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.version_requirements
          raise e
        elsif dep !~ spec
          e = Gem::LoadError.new "can't activate #{dep}, already activated #{spec.full_name}. " \
                                 "Make sure all dependencies are added to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.version_requirements
          raise e
        end

        true
      end

      # === Following hacks are to improve on the generated bin wrappers ===

      # Yeah, talk about a hack
      source_index_class = (class << Gem::SourceIndex ; self ; end)
      source_index_class.send(:define_method, :from_gems_in) do |*args|
        source_index = Gem::SourceIndex.new
        source_index.spec_dirs = *args
        source_index.add_specs(*specs)
        source_index
      end

      # OMG more hacks
      gem_class = (class << Gem ; self ; end)
      gem_class.send(:define_method, :bin_path) do |name, *args|
        exec_name, *reqs = args

        spec = nil

        if exec_name
          spec = specs.find { |s| s.executables.include?(exec_name) }
          spec or raise Gem::Exception, "can't find executable #{exec_name}"
        else
          spec = specs.find  { |s| s.name == name }
          exec_name = spec.default_executable or raise Gem::Exception, "no default executable for #{spec.full_name}"
        end

        File.join(spec.full_gem_path, spec.bindir, exec_name)
      end
    end

    extend self
  end
end

module Bundler
  LOCKED_BY    = '0.9.7'
  FINGERPRINT  = "4cfdc6296aa40847fbe147124a49abb2104013ef"
  AUTOREQUIRES = {:test=>[["factory_girl", false], ["webrat", false], ["relevance-rcov", false], ["roodi", false], ["celerity", false], ["shoulda", false], ["rspec", false], ["culerity", false], ["rspec-rails", false], ["cucumber", false]], :default=>[["clearance", false], ["bundler", false], ["capistrano-ext", false], ["javan-whenever", false], ["ahamid-postgres-pr", false], ["nokogiri", false], ["curb", false], ["paperclip", false], ["capistrano", false], ["rails", false]]}
  SPECS        = [
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/activesupport-2.3.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/activesupport-2.3.4.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/builder-2.1.2/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/builder-2.1.2.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/clearance-0.8.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/clearance-0.8.3.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/json_pure-1.2.0/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/json_pure-1.2.0.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/chronic-0.2.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/chronic-0.2.3.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/bundler-0.6.0/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/bundler-0.6.0.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/net-ssh-2.0.20/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/net-ssh-2.0.20.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/net-scp-1.0.2/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/net-scp-1.0.2.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/net-ssh-gateway-1.0.1/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/net-ssh-gateway-1.0.1.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/capistrano-ext-1.2.1/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/capistrano-ext-1.2.1.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/ruby_parser-2.0.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/ruby_parser-2.0.4.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/factory_girl-1.2.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/factory_girl-1.2.3.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/javan-whenever-0.3.6/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/javan-whenever-0.3.6.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/rack-1.0.1/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/rack-1.0.1.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/actionpack-2.3.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/actionpack-2.3.4.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/actionmailer-2.3.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/actionmailer-2.3.4.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/webrat-0.5.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/webrat-0.5.3.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/relevance-rcov-0.9.2.1/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/relevance-rcov-0.9.2.1.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/rubyforge-2.0.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/rubyforge-2.0.3.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/roodi-2.0.0/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/roodi-2.0.0.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/celerity-0.7.5/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/celerity-0.7.5.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/ahamid-postgres-pr-0.6.1/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/ahamid-postgres-pr-0.6.1.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/shoulda-2.10.2/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/shoulda-2.10.2.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/rake-0.8.7/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/rake-0.8.7.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/gemcutter-0.3.0/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/gemcutter-0.3.0.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/hoe-2.5.0/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/hoe-2.5.0.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/nokogiri-1.2.3/lib", "/home/joe/work/ringtings/gems/gems/nokogiri-1.2.3/ext"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/nokogiri-1.2.3.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/sexp_processor-3.0.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/sexp_processor-3.0.3.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/highline-1.5.2/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/highline-1.5.2.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/diff-lcs-1.1.2/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/diff-lcs-1.1.2.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/rspec-1.2.9/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/rspec-1.2.9.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/culerity-0.2.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/culerity-0.2.3.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/rspec-rails-1.2.7.1/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/rspec-rails-1.2.7.1.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/curb-0.5.4.0/lib", "/home/joe/work/ringtings/gems/gems/curb-0.5.4.0/ext"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/curb-0.5.4.0.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/polyglot-0.2.9/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/polyglot-0.2.9.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/treetop-1.4.2/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/treetop-1.4.2.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/activerecord-2.3.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/activerecord-2.3.4.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/paperclip-2.3.1.1/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/paperclip-2.3.1.1.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/net-sftp-2.0.4/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/net-sftp-2.0.4.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/capistrano-2.5.8/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/capistrano-2.5.8.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/activeresource-2.3.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/activeresource-2.3.4.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/rails-2.3.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/rails-2.3.4.gemspec"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p248/gems/term-ansicolor-1.0.4/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p248/specifications/term-ansicolor-1.0.4.gemspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/cucumber-0.4.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/cucumber-0.4.3.gemspec"},
      ].map do |hash|
    spec = eval(File.read(hash[:loaded_from]), binding, hash[:loaded_from])
    spec.loaded_from = hash[:loaded_from]
    spec.require_paths = hash[:load_paths]
    spec
  end

  extend SharedHelpers

  def self.match_fingerprint
    print = Digest::SHA1.hexdigest(File.read(File.expand_path('../../Gemfile', __FILE__)))
    unless print == FINGERPRINT
      abort 'Gemfile changed since you last locked. Please `bundle lock` to relock.'
    end
  end

  def self.setup(*groups)
    match_fingerprint
    clean_load_path
    cripple_rubygems(SPECS)
    SPECS.each do |spec|
      Gem.loaded_specs[spec.name] = spec
      $LOAD_PATH.unshift(*spec.require_paths)
    end
  end

  def self.require(*groups)
    groups = [:default] if groups.empty?
    groups.each do |group|
      (AUTOREQUIRES[group] || []).each do |file, explicit|
        if explicit
          Kernel.require file
        else
          begin
            Kernel.require file
          rescue LoadError
          end
        end
      end
    end
  end

  # Setup bundle when it's required.
  setup
end