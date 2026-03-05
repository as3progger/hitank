Gem.pre_uninstall do |uninstaller|
  next unless uninstaller.spec.name == "hitank"

  skills_dir = File.expand_path("~/.claude/skills")
  if Dir.exist?(skills_dir) && !(Dir.entries(skills_dir) - %w[. ..]).empty?
    installed = (Dir.entries(skills_dir) - %w[. ..]).join(", ")
    puts "Removing installed skills: #{installed}"
    FileUtils.rm_rf(skills_dir)
    puts "Cleaned up #{skills_dir}"
  end
end
