Gem::Specification.new do |s|
  s.name        = 'public_attributes'
  s.version     = '0.0.5'
  s.date        = '2017-04-26'
  s.summary     = "Public Attributes"
  s.description = "Simple public vs private attribute filtering for Ruby objects."
  s.authors     = ["Nathan Hackley"]
  s.email       = 'nathanhackley@gmail.com'
  s.files       = ["lib/public_attributes.rb"]
  s.homepage    = 'http://rubygems.org/gems/public_attributes'
  s.license     = 'MIT'

  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-fsevent"
end
