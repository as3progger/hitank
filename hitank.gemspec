require_relative "lib/hitank/version"

Gem::Specification.new do |s|
  s.name        = "hitank"
  s.version     = Hitank::VERSION
  s.summary     = "Claude Code skills written in Ruby. Zero gems, zero magic."
  s.description = "A CLI to install Claude Code skills written in pure Ruby (stdlib only). " \
                  "Skills are fetched from GitHub and installed to ~/.claude/skills/."
  s.authors     = ["Alan Alves"]
  s.email       = ["alanalvestech@gmail.com"]
  s.homepage    = "https://github.com/alanalvestech/hitank"
  s.license     = "MIT"

  s.required_ruby_version = ">= 3.0"

  s.files         = Dir["lib/**/*.rb", "bin/*", "LICENSE", "README.md"]
  s.executables   = ["hitank"]
  s.require_paths = ["lib"]

  s.metadata = {
    "source_code_uri"   => "https://github.com/alanalvestech/hitank",
    "bug_tracker_uri"   => "https://github.com/alanalvestech/hitank/issues",
    "changelog_uri"     => "https://github.com/alanalvestech/hitank/releases"
  }
end
