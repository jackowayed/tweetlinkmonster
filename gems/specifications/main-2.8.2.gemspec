Gem::Specification.new do |s|
  s.name = %q{main}
  s.version = "2.8.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ara T. Howard"]
  s.date = %q{2008-07-13}
  s.email = %q{ara.t.howard@gmail.com}
  s.files = ["gemspec.rb", "gen_readme.rb", "install.rb", "lib", "lib/main", "lib/main/base.rb", "lib/main/cast.rb", "lib/main/factories.rb", "lib/main/getoptlong.rb", "lib/main/logger.rb", "lib/main/mode.rb", "lib/main/parameter.rb", "lib/main/softspoken.rb", "lib/main/stdext.rb", "lib/main/usage.rb", "lib/main/util.rb", "lib/main.rb", "README", "samples", "samples/a.rb", "samples/b.rb", "samples/c.rb", "samples/d.rb", "samples/e.rb", "samples/f.rb", "samples/g.rb", "test", "test/main.rb", "TODO"]
  s.homepage = %q{http://codeforpeople.com/lib/ruby/main/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{codeforpeople}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{main}
  s.test_files = ["test/main.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<fattr>, [">= 1.0.3"])
      s.add_runtime_dependency(%q<arrayfields>, [">= 4.5.0"])
    else
      s.add_dependency(%q<fattr>, [">= 1.0.3"])
      s.add_dependency(%q<arrayfields>, [">= 4.5.0"])
    end
  else
    s.add_dependency(%q<fattr>, [">= 1.0.3"])
    s.add_dependency(%q<arrayfields>, [">= 4.5.0"])
  end
end
