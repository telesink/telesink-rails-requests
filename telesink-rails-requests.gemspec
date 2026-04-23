require_relative "lib/telesink/rails/requests/version"

Gem::Specification.new do |s|
  s.name        = "telesink-rails-requests"
  s.version     = Telesink::Rails::Requests::VERSION
  s.summary     = "Rails request tracking for Telesink"
  s.description = "Automatically tracks HTTP requests in Rails apps using Telesink."
  s.authors     = ["Kyrylo Silin"]
  s.email       = ["kyrylo@telesink.com"]
  s.homepage    = "https://github.com/telesink/telesink-rails-requests"
  s.license     = "MIT"

  s.files = Dir["lib/**/*", "LICENSE.md", "README.md", "CHANGELOG.md"]

  s.required_ruby_version = ">= 3.1"

  s.add_dependency "railties", ">= 7.0"
  s.add_dependency "telesink", ">= 1.0.0"
end
