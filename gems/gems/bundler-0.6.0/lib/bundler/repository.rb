module Bundler
  class InvalidRepository < StandardError ; end

  class Repository
    attr_reader :path

    def initialize(path, bindir)
      FileUtils.mkdir_p(path)

      @path   = Pathname.new(path)
      @bindir = Pathname.new(bindir)

      @cache = GemDirectorySource.new(:location => @path.join("cache"))
    end

    def install(dependencies, sources, options = {})
      # TODO: clean this up
      sources.each do |s|
        s.repository = self
        s.local = options[:cached]
      end

      begin
        valid = Resolver.resolve(dependencies, [source_index])
      rescue Bundler::GemNotFound
      end

      if options[:cached]
        sources = sources.select { |s| s.can_be_local? }
      end

      if options[:update] || !valid
        Bundler.logger.info "Calculating dependencies..."
        bundle = Resolver.resolve(dependencies, [@cache] + sources)
        do_install(bundle, options)
        valid = bundle
      end
      cleanup(valid)
      configure(valid, options)
    end

    def cache(*gemfiles)
      FileUtils.mkdir_p(@path.join("cache"))
      gemfiles.each do |gemfile|
        Bundler.logger.info "Caching: #{File.basename(gemfile)}"
        FileUtils.cp(gemfile, @path.join("cache"))
      end
    end

    def prune(dependencies, sources)
      sources.each do |s|
        s.repository = self
        s.local = true
      end

      sources = sources.select { |s| s.can_be_local? }
      bundle = Resolver.resolve(dependencies, [@cache] + sources)
      @cache.gems.each do |name, spec|
        unless bundle.any? { |s| s.name == spec.name && s.version == spec.version }
          Bundler.logger.info "Pruning #{spec.name} (#{spec.version}) from the cache"
          FileUtils.rm @path.join("cache", "#{spec.full_name}.gem")
        end
      end
    end

    def gems
      source_index.gems.values
    end

    def source_index
      index = Gem::SourceIndex.from_gems_in(@path.join("specifications"))
      index.each { |n, spec| spec.loaded_from = @path.join("specifications", "#{spec.full_name}.gemspec") }
      index
    end

    def download_path_for(type)
      @repos[type].download_path_for
    end

  private

    def do_install(bundle, options)
      bundle.download

      bundle.each do |spec|
        spec.loaded_from = @path.join("specifications", "#{spec.full_name}.gemspec")
        # Do nothing if the gem is already expanded
        next if @path.join("gems", spec.full_name).directory?

        case spec.source
        when GemSource, GemDirectorySource, SystemGemSource
          expand_gemfile(spec, options)
        else
          expand_vendored_gem(spec, options)
        end
      end
    end

    def expand_gemfile(spec, options)
      Bundler.logger.info "Installing #{spec.name} (#{spec.version})"

      gemfile = @path.join("cache", "#{spec.full_name}.gem").to_s

      installer = Gem::Installer.new(gemfile, options.merge(
        :install_dir         => @path,
        :ignore_dependencies => true,
        :env_shebang         => true,
        :wrappers            => true,
        :bin_dir             => @bindir
      ))
      installer.install
    end

    def expand_vendored_gem(spec, options)
      add_spec(spec)
      FileUtils.mkdir_p(@path.join("gems"))
      File.symlink(spec.location, @path.join("gems", spec.full_name))

      # HAX -- Generate the bin
      bin_dir = @bindir
      path    = @path
      installer = Gem::Installer.allocate
      installer.instance_eval do
        @spec     = spec
        @bin_dir  = bin_dir
        @gem_dir  = path.join("gems", "#{spec.full_name}")
        @gem_home = path
        @wrappers = true
      end
      installer.generate_bin
    end

    def add_spec(spec)
      destination = path.join('specifications')
      destination.mkdir unless destination.exist?

      File.open(destination.join("#{spec.full_name}.gemspec"), 'w') do |f|
        f.puts spec.to_ruby
      end
    end

    def cleanup(valid)
      to_delete = gems
      to_delete.delete_if do |spec|
        valid.any? { |other| spec.name == other.name && spec.version == other.version }
      end

      valid_executables = valid.map { |s| s.executables }.flatten.compact

      to_delete.each do |spec|
        Bundler.logger.info "Deleting gem: #{spec.name} (#{spec.version})"
        FileUtils.rm_rf(@path.join("specifications", "#{spec.full_name}.gemspec"))
        FileUtils.rm_rf(@path.join("gems", spec.full_name))
        # Cleanup the bin directory
        spec.executables.each do |bin|
          next if valid_executables.include?(bin)
          Bundler.logger.info "Deleting bin file: #{bin}"
          FileUtils.rm_rf(@bindir.join(bin))
        end
      end
    end

    def expand(options)
      each_repo do |repo|
        repo.expand(options)
      end
    end

    def configure(specs, options)
      generate_environment(specs, options)
    end

    def generate_environment(specs, options)
      FileUtils.mkdir_p(path)

      load_paths = load_paths_for_specs(specs)
      bindir     = @bindir.relative_path_from(path).to_s
      filename   = options[:manifest].relative_path_from(path).to_s
      spec_files = specs.inject({}) do |hash, spec|
        relative = spec.loaded_from.relative_path_from(@path).to_s
        hash.merge!(spec.name => relative)
      end

      File.open(path.join("environment.rb"), "w") do |file|
        template = File.read(File.join(File.dirname(__FILE__), "templates", "environment.erb"))
        erb = ERB.new(template, nil, '-')
        file.puts erb.result(binding)
      end
    end

    def load_paths_for_specs(specs)
      load_paths = []
      specs.each do |spec|
        gem_path = Pathname.new(spec.full_gem_path)
        if spec.bindir
          load_paths << gem_path.join(spec.bindir).relative_path_from(@path).to_s
        end
        spec.require_paths.each do |path|
          load_paths << gem_path.join(path).relative_path_from(@path).to_s
        end
      end
      load_paths
    end

    def require_code(file, dep)
      constraint = case
      when dep.only   then %{ if #{dep.only.inspect}.include?(env)}
      when dep.except then %{ unless #{dep.except.inspect}.include?(env)}
      end
      "require #{file.inspect}#{constraint}"
    end
  end
end
