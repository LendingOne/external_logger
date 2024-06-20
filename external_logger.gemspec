# frozen_string_literal: true

require_relative "lib/external_logger/version"

Gem::Specification.new do |spec|
  spec.name          = "external_logger"
  spec.version       = ExternalLogger::VERSION
  spec.authors       = ["Artur Gin"]
  spec.email         = ["art.rad.gin@proton.me"]

  spec.summary       = "JR external logger adapter"
  spec.description   = "JR external logger adapter"
  spec.homepage      = "https://github.com/ArturGin/request_enforcer"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "appsignal", "~> 3.7.5"
  spec.add_dependency "rollbar"
end
