Gem::Specification.new do |s|
  s.name = %q{crypt}
  s.version = "1.1.4"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Kernahan"]
  s.cert_chain = nil
  s.date = %q{2006-08-06}
  s.email = %q{kernighan_rich@rubyforge.org}
  s.files = ["crypt/blowfish-tables.rb", "crypt/blowfish.rb", "crypt/cbc.rb", "crypt/gost.rb", "crypt/idea.rb", "crypt/noise.rb", "crypt/purerubystringio.rb", "crypt/rijndael-tables.rb", "crypt/rijndael.rb", "crypt/stringxor.rb", "test/break-idea.rb", "test/devServer.rb", "test/test-blowfish.rb", "test/test-gost.rb", "test/test-idea.rb", "test/test-rijndael.rb"]
  s.homepage = %q{http://crypt.rubyforge.org/}
  s.require_paths = ["."]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{crypt}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{The Crypt library is a pure-ruby implementation of a number of popular encryption algorithms. Block cyphers currently include Blowfish, GOST, IDEA, and Rijndael (AES). Cypher Block Chaining (CBC) has been implemented. Twofish, Serpent, and CAST256 are planned for release soon.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 1

    if current_version >= 3 then
    else
    end
  else
  end
end
