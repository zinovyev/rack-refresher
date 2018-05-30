Gem::Specification.new do |s|
  s.name        = "rack-refresher"
  s.version     = "1.0.0"
  s.date        = "2018-05-30"
  s.summary     = "Rack middleware for authomatic page refresh"
  s.description = "Refresh the content of your page with a given interval"
  s.authors     = ["Ivan Zinovyev"]
  s.email       = "ivan@zinovyev.net"
  s.files       = %w[lib/rack-refresher.rb lib/rack/refresher.rb]
  s.homepage    = "https://github.com/zinovyev/rack-refresher"
  s.license     = "MIT"
  s.add_runtime_dependency "rack"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec", "~> 3.7"
end
