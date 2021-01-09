require_relative 'lib/lab1/gem/version'

Gem::Specification.new do |spec|
  spec.name          = "lab1-gem"
  spec.version       = Lab1::Gem::VERSION
  spec.authors       = ["MykeMalyar"]
  spec.email         = ["michaelbodybuilder1999@gmail.com"]

  spec.summary       = "Lab1 Ruby"
  spec.description   = "Lab1 Ruby"
  spec.homepage      = "https://github.com/MikeMalyar"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/MikeMalyar/lab1-gem"
  spec.metadata["changelog_uri"] = "https://github.com/MikeMalyar/lab1-gem/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
