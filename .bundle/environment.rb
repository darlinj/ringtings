# DO NOT MODIFY THIS FILE
# Generated by Bundler 0.9.21

require 'digest/sha1'
require 'yaml'
require 'pathname'
require 'rubygems'
Gem.source_index # ensure Rubygems is fully loaded in Ruby 1.9

module Gem
  class Dependency
    if !instance_methods.map { |m| m.to_s }.include?("requirement")
      def requirement
        version_requirements
      end
    end
  end
end

module Bundler
  class Specification < Gem::Specification
    attr_accessor :relative_loaded_from

    def self.from_gemspec(gemspec)
      spec = allocate
      gemspec.instance_variables.each do |ivar|
        spec.instance_variable_set(ivar, gemspec.instance_variable_get(ivar))
      end
      spec
    end

    def loaded_from
      return super unless relative_loaded_from
      source.path.join(relative_loaded_from).to_s
    end

    def full_gem_path
      Pathname.new(loaded_from).dirname.expand_path.to_s
    end

  end

  module SharedHelpers
    attr_accessor :gem_loaded

    def default_gemfile
      gemfile = find_gemfile
      gemfile or raise GemfileNotFound, "Could not locate Gemfile"
      Pathname.new(gemfile)
    end

    def in_bundle?
      find_gemfile
    end

    def env_file
      default_gemfile.dirname.join(".bundle/environment.rb")
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
      Gem.source_index # ensure RubyGems is fully loaded

     ::Kernel.class_eval do
        private
        def gem(*) ; end
      end

      ::Kernel.send(:define_method, :gem) do |dep, *reqs|
        if executables.include? File.basename(caller.first.split(':').first)
          return
        end
        opts = reqs.last.is_a?(Hash) ? reqs.pop : {}

        unless dep.respond_to?(:name) && dep.respond_to?(:requirement)
          dep = Gem::Dependency.new(dep, reqs)
        end

        spec = specs.find  { |s| s.name == dep.name }

        if spec.nil?
          e = Gem::LoadError.new "#{dep.name} is not part of the bundle. Add it to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        elsif dep !~ spec
          e = Gem::LoadError.new "can't activate #{dep}, already activated #{spec.full_name}. " \
                                 "Make sure all dependencies are added to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
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

        gem_bin = File.join(spec.full_gem_path, spec.bindir, exec_name)
        gem_from_path_bin = File.join(File.dirname(spec.loaded_from), spec.bindir, exec_name)
        File.exist?(gem_bin) ? gem_bin : gem_from_path_bin
      end
    end

    extend self
  end
end

module Bundler
  LOCKED_BY    = '0.9.21'
  FINGERPRINT  = "86d0ed937c732c14ca378ad6d757d00ae29dea58"
  HOME         = '/home/joe/work/ringtings/gems/bundler'
  AUTOREQUIRES = {:test=>[["cucumber", false], ["rspec", false], ["culerity", false], ["factory_girl", false], ["relevance-rcov", false], ["roodi", false], ["rspec-rails", false], ["shoulda", false], ["webrat", false]], :default=>[["ahamid-postgres-pr", false], ["bundler", false], ["capistrano", false], ["capistrano-ext", false], ["clearance", false], ["curb", false], ["javan-whenever", false], ["nokogiri", false], ["paperclip", false], ["rails", false], ["whenever", false]]}
  SPECS        = [
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p174/gems/rake-0.8.7/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p174/specifications/rake-0.8.7.gemspec", :name=>"rake"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/activesupport-2.3.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/activesupport-2.3.4.gemspec", :name=>"activesupport"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p174/gems/rack-1.0.1/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p174/specifications/rack-1.0.1.gemspec", :name=>"rack"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/actionpack-2.3.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/actionpack-2.3.4.gemspec", :name=>"actionpack"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/actionmailer-2.3.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/actionmailer-2.3.4.gemspec", :name=>"actionmailer"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/activerecord-2.3.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/activerecord-2.3.4.gemspec", :name=>"activerecord"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/activeresource-2.3.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/activeresource-2.3.4.gemspec", :name=>"activeresource"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/ahamid-postgres-pr-0.6.1/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/ahamid-postgres-pr-0.6.1.gemspec", :name=>"ahamid-postgres-pr"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p174/gems/builder-2.1.2/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p174/specifications/builder-2.1.2.gemspec", :name=>"builder"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/bundler-0.6.0/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/bundler-0.6.0.gemspec", :name=>"bundler"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p174/gems/highline-1.5.2/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p174/specifications/highline-1.5.2.gemspec", :name=>"highline"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/net-ssh-2.0.22/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/net-ssh-2.0.22.gemspec", :name=>"net-ssh"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p174/gems/net-scp-1.0.2/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p174/specifications/net-scp-1.0.2.gemspec", :name=>"net-scp"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p174/gems/net-sftp-2.0.4/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p174/specifications/net-sftp-2.0.4.gemspec", :name=>"net-sftp"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p174/gems/net-ssh-gateway-1.0.1/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p174/specifications/net-ssh-gateway-1.0.1.gemspec", :name=>"net-ssh-gateway"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/capistrano-2.5.8/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/capistrano-2.5.8.gemspec", :name=>"capistrano"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/capistrano-ext-1.2.1/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/capistrano-ext-1.2.1.gemspec", :name=>"capistrano-ext"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p174/gems/json_pure-1.2.4/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p174/specifications/json_pure-1.2.4.gemspec", :name=>"json_pure"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/rubyforge-2.0.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/rubyforge-2.0.4.gemspec", :name=>"rubyforge"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p174/gems/hoe-2.6.0/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p174/specifications/hoe-2.6.0.gemspec", :name=>"hoe"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/chronic-0.2.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/chronic-0.2.3.gemspec", :name=>"chronic"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/clearance-0.8.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/clearance-0.8.3.gemspec", :name=>"clearance"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p174/gems/diff-lcs-1.1.2/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p174/specifications/diff-lcs-1.1.2.gemspec", :name=>"diff-lcs"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/polyglot-0.2.9/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/polyglot-0.2.9.gemspec", :name=>"polyglot"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/term-ansicolor-1.0.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/term-ansicolor-1.0.4.gemspec", :name=>"term-ansicolor"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/treetop-1.4.2/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/treetop-1.4.2.gemspec", :name=>"treetop"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/cucumber-0.4.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/cucumber-0.4.3.gemspec", :name=>"cucumber"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/rspec-1.2.9/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/rspec-1.2.9.gemspec", :name=>"rspec"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/culerity-0.2.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/culerity-0.2.3.gemspec", :name=>"culerity"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/curb-0.5.4.0/lib", "/home/joe/work/ringtings/gems/gems/curb-0.5.4.0/ext"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/curb-0.5.4.0.gemspec", :name=>"curb"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/factory_girl-1.2.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/factory_girl-1.2.3.gemspec", :name=>"factory_girl"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/javan-whenever-0.3.6/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/javan-whenever-0.3.6.gemspec", :name=>"javan-whenever"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/nokogiri-1.2.3/lib", "/home/joe/work/ringtings/gems/gems/nokogiri-1.2.3/ext"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/nokogiri-1.2.3.gemspec", :name=>"nokogiri"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/paperclip-2.3.1.1/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/paperclip-2.3.1.1.gemspec", :name=>"paperclip"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/rack-test-0.5.3/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/rack-test-0.5.3.gemspec", :name=>"rack-test"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/rails-2.3.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/rails-2.3.4.gemspec", :name=>"rails"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/relevance-rcov-0.9.2.1/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/relevance-rcov-0.9.2.1.gemspec", :name=>"relevance-rcov"},
        {:load_paths=>["/home/joe/.rvm/gems/ruby-1.8.7-p174/gems/sexp_processor-3.0.4/lib"], :loaded_from=>"/home/joe/.rvm/gems/ruby-1.8.7-p174/specifications/sexp_processor-3.0.4.gemspec", :name=>"sexp_processor"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/ruby_parser-2.0.4/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/ruby_parser-2.0.4.gemspec", :name=>"ruby_parser"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/roodi-2.0.0/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/roodi-2.0.0.gemspec", :name=>"roodi"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/rspec-rails-1.2.7.1/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/rspec-rails-1.2.7.1.gemspec", :name=>"rspec-rails"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/shoulda-2.10.2/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/shoulda-2.10.2.gemspec", :name=>"shoulda"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/webrat-0.7.0/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/webrat-0.7.0.gemspec", :name=>"webrat"},
        {:load_paths=>["/home/joe/work/ringtings/gems/gems/whenever-0.4.1/lib"], :loaded_from=>"/home/joe/work/ringtings/gems/specifications/whenever-0.4.1.gemspec", :name=>"whenever"},
      ].map do |hash|
    if hash[:virtual_spec]
      spec = eval(hash[:virtual_spec], TOPLEVEL_BINDING, "<virtual spec for '#{hash[:name]}'>")
    else
      dir = File.dirname(hash[:loaded_from])
      spec = Dir.chdir(dir){ eval(File.read(hash[:loaded_from]), TOPLEVEL_BINDING, hash[:loaded_from]) }
    end
    spec.loaded_from = hash[:loaded_from]
    spec.require_paths = hash[:load_paths]
    if spec.loaded_from.include?(HOME)
      Bundler::Specification.from_gemspec(spec)
    else
      spec
    end
  end

  extend SharedHelpers

  def self.configure_gem_path_and_home(specs)
    # Fix paths, so that Gem.source_index and such will work
    paths = specs.map{|s| s.installation_path }
    paths.flatten!; paths.compact!; paths.uniq!; paths.reject!{|p| p.empty? }
    ENV['GEM_PATH'] = paths.join(File::PATH_SEPARATOR)
    ENV['GEM_HOME'] = paths.first
    Gem.clear_paths
  end

  def self.match_fingerprint
    lockfile = File.expand_path('../../Gemfile.lock', __FILE__)
    lock_print = YAML.load(File.read(lockfile))["hash"] if File.exist?(lockfile)
    gem_print = Digest::SHA1.hexdigest(File.read(File.expand_path('../../Gemfile', __FILE__)))

    unless gem_print == lock_print
      abort 'Gemfile changed since you last locked. Please run `bundle lock` to relock.'
    end

    unless gem_print == FINGERPRINT
      abort 'Your bundled environment is out of date. Run `bundle install` to regenerate it.'
    end
  end

  def self.setup(*groups)
    match_fingerprint
    clean_load_path
    cripple_rubygems(SPECS)
    configure_gem_path_and_home(SPECS)
    SPECS.each do |spec|
      Gem.loaded_specs[spec.name] = spec
      spec.require_paths.each do |path|
        $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
      end
    end
    self
  end

  def self.require(*groups)
    groups = [:default] if groups.empty?
    groups.each do |group|
      (AUTOREQUIRES[group.to_sym] || []).each do |file, explicit|
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

  # Set up load paths unless this file is being loaded after the Bundler gem
  setup unless @gem_loaded
end
