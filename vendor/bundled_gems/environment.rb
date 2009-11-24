# DO NOT MODIFY THIS FILE
module Bundler
 file = File.expand_path(__FILE__)
 dir = File.dirname(file)

  ENV["GEM_HOME"] = dir
  ENV["GEM_PATH"] = dir
  ENV["PATH"]     = "#{dir}/bin:#{ENV["PATH"]}"
  ENV["RUBYOPT"]  = "-r#{file} #{ENV["RUBYOPT"]}"

  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activesupport-2.3.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activesupport-2.3.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/builder-2.1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/builder-2.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/clearance-0.8.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/clearance-0.8.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/thoughtbot-shoulda-2.10.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/thoughtbot-shoulda-2.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json_pure-1.2.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json_pure-1.2.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/bundler-0.6.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/bundler-0.6.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby_parser-2.0.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby_parser-2.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/factory_girl-1.2.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/factory_girl-1.2.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-2.0.15/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-2.0.15/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-scp-1.0.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-scp-1.0.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-gateway-1.0.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-gateway-1.0.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-ext-1.2.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-ext-1.2.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/javan-whenever-0.3.6/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/javan-whenever-0.3.6/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/relevance-rcov-0.9.2.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/relevance-rcov-0.9.2.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rack-1.0.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rack-1.0.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/actionpack-2.3.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/actionpack-2.3.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/actionmailer-2.3.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/actionmailer-2.3.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/webrat-0.5.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/webrat-0.5.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rubyforge-2.0.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rubyforge-2.0.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/celerity-0.7.5/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/celerity-0.7.5/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ahamid-postgres-pr-0.6.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ahamid-postgres-pr-0.6.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/roodi-2.0.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/roodi-2.0.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/highline-1.5.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/highline-1.5.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/diff-lcs-1.1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/diff-lcs-1.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-1.2.9/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-1.2.9/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/culerity-0.2.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/culerity-0.2.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-rails-1.2.7.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-rails-1.2.7.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/polyglot-0.2.9/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/polyglot-0.2.9/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/treetop-1.4.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/treetop-1.4.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rake-0.8.7/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rake-0.8.7/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hoe-2.3.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hoe-2.3.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.2.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.2.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.2.3/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/sexp_processor-3.0.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/sexp_processor-3.0.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/chronic-0.2.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/chronic-0.2.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/curb-0.5.4.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/curb-0.5.4.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/curb-0.5.4.0/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activerecord-2.3.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activerecord-2.3.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activeresource-2.3.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activeresource-2.3.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rails-2.3.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rails-2.3.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-sftp-2.0.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-sftp-2.0.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-2.5.8/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-2.5.8/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/term-ansicolor-1.0.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/term-ansicolor-1.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/cucumber-0.4.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/cucumber-0.4.3/lib")

  @gemfile = "#{dir}/../../Gemfile"

  require "rubygems"

  @bundled_specs = {}
  @bundled_specs["activesupport"] = eval(File.read("#{dir}/specifications/activesupport-2.3.4.gemspec"))
  @bundled_specs["activesupport"].loaded_from = "#{dir}/specifications/activesupport-2.3.4.gemspec"
  @bundled_specs["builder"] = eval(File.read("#{dir}/specifications/builder-2.1.2.gemspec"))
  @bundled_specs["builder"].loaded_from = "#{dir}/specifications/builder-2.1.2.gemspec"
  @bundled_specs["clearance"] = eval(File.read("#{dir}/specifications/clearance-0.8.3.gemspec"))
  @bundled_specs["clearance"].loaded_from = "#{dir}/specifications/clearance-0.8.3.gemspec"
  @bundled_specs["thoughtbot-shoulda"] = eval(File.read("#{dir}/specifications/thoughtbot-shoulda-2.10.1.gemspec"))
  @bundled_specs["thoughtbot-shoulda"].loaded_from = "#{dir}/specifications/thoughtbot-shoulda-2.10.1.gemspec"
  @bundled_specs["json_pure"] = eval(File.read("#{dir}/specifications/json_pure-1.2.0.gemspec"))
  @bundled_specs["json_pure"].loaded_from = "#{dir}/specifications/json_pure-1.2.0.gemspec"
  @bundled_specs["bundler"] = eval(File.read("#{dir}/specifications/bundler-0.6.0.gemspec"))
  @bundled_specs["bundler"].loaded_from = "#{dir}/specifications/bundler-0.6.0.gemspec"
  @bundled_specs["ruby_parser"] = eval(File.read("#{dir}/specifications/ruby_parser-2.0.4.gemspec"))
  @bundled_specs["ruby_parser"].loaded_from = "#{dir}/specifications/ruby_parser-2.0.4.gemspec"
  @bundled_specs["factory_girl"] = eval(File.read("#{dir}/specifications/factory_girl-1.2.3.gemspec"))
  @bundled_specs["factory_girl"].loaded_from = "#{dir}/specifications/factory_girl-1.2.3.gemspec"
  @bundled_specs["net-ssh"] = eval(File.read("#{dir}/specifications/net-ssh-2.0.15.gemspec"))
  @bundled_specs["net-ssh"].loaded_from = "#{dir}/specifications/net-ssh-2.0.15.gemspec"
  @bundled_specs["net-scp"] = eval(File.read("#{dir}/specifications/net-scp-1.0.2.gemspec"))
  @bundled_specs["net-scp"].loaded_from = "#{dir}/specifications/net-scp-1.0.2.gemspec"
  @bundled_specs["net-ssh-gateway"] = eval(File.read("#{dir}/specifications/net-ssh-gateway-1.0.1.gemspec"))
  @bundled_specs["net-ssh-gateway"].loaded_from = "#{dir}/specifications/net-ssh-gateway-1.0.1.gemspec"
  @bundled_specs["capistrano-ext"] = eval(File.read("#{dir}/specifications/capistrano-ext-1.2.1.gemspec"))
  @bundled_specs["capistrano-ext"].loaded_from = "#{dir}/specifications/capistrano-ext-1.2.1.gemspec"
  @bundled_specs["javan-whenever"] = eval(File.read("#{dir}/specifications/javan-whenever-0.3.6.gemspec"))
  @bundled_specs["javan-whenever"].loaded_from = "#{dir}/specifications/javan-whenever-0.3.6.gemspec"
  @bundled_specs["relevance-rcov"] = eval(File.read("#{dir}/specifications/relevance-rcov-0.9.2.1.gemspec"))
  @bundled_specs["relevance-rcov"].loaded_from = "#{dir}/specifications/relevance-rcov-0.9.2.1.gemspec"
  @bundled_specs["rack"] = eval(File.read("#{dir}/specifications/rack-1.0.1.gemspec"))
  @bundled_specs["rack"].loaded_from = "#{dir}/specifications/rack-1.0.1.gemspec"
  @bundled_specs["actionpack"] = eval(File.read("#{dir}/specifications/actionpack-2.3.4.gemspec"))
  @bundled_specs["actionpack"].loaded_from = "#{dir}/specifications/actionpack-2.3.4.gemspec"
  @bundled_specs["actionmailer"] = eval(File.read("#{dir}/specifications/actionmailer-2.3.4.gemspec"))
  @bundled_specs["actionmailer"].loaded_from = "#{dir}/specifications/actionmailer-2.3.4.gemspec"
  @bundled_specs["webrat"] = eval(File.read("#{dir}/specifications/webrat-0.5.3.gemspec"))
  @bundled_specs["webrat"].loaded_from = "#{dir}/specifications/webrat-0.5.3.gemspec"
  @bundled_specs["rubyforge"] = eval(File.read("#{dir}/specifications/rubyforge-2.0.3.gemspec"))
  @bundled_specs["rubyforge"].loaded_from = "#{dir}/specifications/rubyforge-2.0.3.gemspec"
  @bundled_specs["celerity"] = eval(File.read("#{dir}/specifications/celerity-0.7.5.gemspec"))
  @bundled_specs["celerity"].loaded_from = "#{dir}/specifications/celerity-0.7.5.gemspec"
  @bundled_specs["ahamid-postgres-pr"] = eval(File.read("#{dir}/specifications/ahamid-postgres-pr-0.6.1.gemspec"))
  @bundled_specs["ahamid-postgres-pr"].loaded_from = "#{dir}/specifications/ahamid-postgres-pr-0.6.1.gemspec"
  @bundled_specs["roodi"] = eval(File.read("#{dir}/specifications/roodi-2.0.0.gemspec"))
  @bundled_specs["roodi"].loaded_from = "#{dir}/specifications/roodi-2.0.0.gemspec"
  @bundled_specs["highline"] = eval(File.read("#{dir}/specifications/highline-1.5.1.gemspec"))
  @bundled_specs["highline"].loaded_from = "#{dir}/specifications/highline-1.5.1.gemspec"
  @bundled_specs["diff-lcs"] = eval(File.read("#{dir}/specifications/diff-lcs-1.1.2.gemspec"))
  @bundled_specs["diff-lcs"].loaded_from = "#{dir}/specifications/diff-lcs-1.1.2.gemspec"
  @bundled_specs["rspec"] = eval(File.read("#{dir}/specifications/rspec-1.2.9.gemspec"))
  @bundled_specs["rspec"].loaded_from = "#{dir}/specifications/rspec-1.2.9.gemspec"
  @bundled_specs["culerity"] = eval(File.read("#{dir}/specifications/culerity-0.2.3.gemspec"))
  @bundled_specs["culerity"].loaded_from = "#{dir}/specifications/culerity-0.2.3.gemspec"
  @bundled_specs["rspec-rails"] = eval(File.read("#{dir}/specifications/rspec-rails-1.2.7.1.gemspec"))
  @bundled_specs["rspec-rails"].loaded_from = "#{dir}/specifications/rspec-rails-1.2.7.1.gemspec"
  @bundled_specs["polyglot"] = eval(File.read("#{dir}/specifications/polyglot-0.2.9.gemspec"))
  @bundled_specs["polyglot"].loaded_from = "#{dir}/specifications/polyglot-0.2.9.gemspec"
  @bundled_specs["treetop"] = eval(File.read("#{dir}/specifications/treetop-1.4.2.gemspec"))
  @bundled_specs["treetop"].loaded_from = "#{dir}/specifications/treetop-1.4.2.gemspec"
  @bundled_specs["rake"] = eval(File.read("#{dir}/specifications/rake-0.8.7.gemspec"))
  @bundled_specs["rake"].loaded_from = "#{dir}/specifications/rake-0.8.7.gemspec"
  @bundled_specs["hoe"] = eval(File.read("#{dir}/specifications/hoe-2.3.3.gemspec"))
  @bundled_specs["hoe"].loaded_from = "#{dir}/specifications/hoe-2.3.3.gemspec"
  @bundled_specs["nokogiri"] = eval(File.read("#{dir}/specifications/nokogiri-1.2.3.gemspec"))
  @bundled_specs["nokogiri"].loaded_from = "#{dir}/specifications/nokogiri-1.2.3.gemspec"
  @bundled_specs["sexp_processor"] = eval(File.read("#{dir}/specifications/sexp_processor-3.0.3.gemspec"))
  @bundled_specs["sexp_processor"].loaded_from = "#{dir}/specifications/sexp_processor-3.0.3.gemspec"
  @bundled_specs["chronic"] = eval(File.read("#{dir}/specifications/chronic-0.2.3.gemspec"))
  @bundled_specs["chronic"].loaded_from = "#{dir}/specifications/chronic-0.2.3.gemspec"
  @bundled_specs["curb"] = eval(File.read("#{dir}/specifications/curb-0.5.4.0.gemspec"))
  @bundled_specs["curb"].loaded_from = "#{dir}/specifications/curb-0.5.4.0.gemspec"
  @bundled_specs["activerecord"] = eval(File.read("#{dir}/specifications/activerecord-2.3.4.gemspec"))
  @bundled_specs["activerecord"].loaded_from = "#{dir}/specifications/activerecord-2.3.4.gemspec"
  @bundled_specs["activeresource"] = eval(File.read("#{dir}/specifications/activeresource-2.3.4.gemspec"))
  @bundled_specs["activeresource"].loaded_from = "#{dir}/specifications/activeresource-2.3.4.gemspec"
  @bundled_specs["rails"] = eval(File.read("#{dir}/specifications/rails-2.3.4.gemspec"))
  @bundled_specs["rails"].loaded_from = "#{dir}/specifications/rails-2.3.4.gemspec"
  @bundled_specs["net-sftp"] = eval(File.read("#{dir}/specifications/net-sftp-2.0.2.gemspec"))
  @bundled_specs["net-sftp"].loaded_from = "#{dir}/specifications/net-sftp-2.0.2.gemspec"
  @bundled_specs["capistrano"] = eval(File.read("#{dir}/specifications/capistrano-2.5.8.gemspec"))
  @bundled_specs["capistrano"].loaded_from = "#{dir}/specifications/capistrano-2.5.8.gemspec"
  @bundled_specs["term-ansicolor"] = eval(File.read("#{dir}/specifications/term-ansicolor-1.0.4.gemspec"))
  @bundled_specs["term-ansicolor"].loaded_from = "#{dir}/specifications/term-ansicolor-1.0.4.gemspec"
  @bundled_specs["cucumber"] = eval(File.read("#{dir}/specifications/cucumber-0.4.3.gemspec"))
  @bundled_specs["cucumber"].loaded_from = "#{dir}/specifications/cucumber-0.4.3.gemspec"

  def self.add_specs_to_loaded_specs
    Gem.loaded_specs.merge! @bundled_specs
  end

  def self.add_specs_to_index
    @bundled_specs.each do |name, spec|
      Gem.source_index.add_spec spec
    end
  end

  add_specs_to_loaded_specs
  add_specs_to_index

  def self.require_env(env = nil)
    context = Class.new do
      def initialize(env) @env = env && env.to_s ; end
      def method_missing(*) ; yield if block_given? ; end
      def only(*env)
        old, @only = @only, _combine_only(env.flatten)
        yield
        @only = old
      end
      def except(*env)
        old, @except = @except, _combine_except(env.flatten)
        yield
        @except = old
      end
      def gem(name, *args)
        opt = args.last.is_a?(Hash) ? args.pop : {}
        only = _combine_only(opt[:only] || opt["only"])
        except = _combine_except(opt[:except] || opt["except"])
        files = opt[:require_as] || opt["require_as"] || name
        files = [files] unless files.respond_to?(:each)

        return unless !only || only.any? {|e| e == @env }
        return if except && except.any? {|e| e == @env }

        if files = opt[:require_as] || opt["require_as"]
          files = Array(files)
          files.each { |f| require f }
        else
          begin
            require name
          rescue LoadError
            # Do nothing
          end
        end
        yield if block_given?
        true
      end
      private
      def _combine_only(only)
        return @only unless only
        only = [only].flatten.compact.uniq.map { |o| o.to_s }
        only &= @only if @only
        only
      end
      def _combine_except(except)
        return @except unless except
        except = [except].flatten.compact.uniq.map { |o| o.to_s }
        except |= @except if @except
        except
      end
    end
    context.new(env && env.to_s).instance_eval(File.read(@gemfile), @gemfile, 1)
  end
end

module Gem
  @loaded_stacks = Hash.new { |h,k| h[k] = [] }

  def source_index.refresh!
    super
    Bundler.add_specs_to_index
  end
end
