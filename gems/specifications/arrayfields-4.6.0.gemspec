Gem::Specification.new do |s|
  s.name = %q{arrayfields}
  s.version = "4.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ara T. Howard"]
  s.autorequire = %q{arrayfields}
  s.date = %q{2008-07-13}
  s.email = %q{ara.t.howard@noaa.gov}
  s.files = ["gemspec.rb", "gen_readme.rb", "install.rb", "lib", "lib/arrayfields.rb", "README", "README.tmpl", "sample", "sample/a.rb", "sample/b.rb", "sample/c.rb", "sample/d.rb", "sample/e.rb", "test", "test/arrayfields.rb", "test/memtest.rb"]
  s.homepage = %q{http://codeforpeople.com/lib/ruby/arrayfields/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{arrayfields}
  s.test_files = ["test/arrayfields.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
