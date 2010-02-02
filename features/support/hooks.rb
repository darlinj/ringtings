Before do |scenario|
  @feature_vars = {}
  User.destroy_all
  load "Rakefile"
  Rake::Task["db:seed"].invoke
end

After do
end
