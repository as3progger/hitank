require 'json'
require 'yaml'
require 'net/http'
require 'uri'
require 'fileutils'
require_relative 'version'
require_relative 'deps'

module Hitank
  class CLI
    REPO = "alanalvestech/hitank"
    BRANCH = "main"
    GLOBAL_DIR = File.expand_path("~/.claude/skills")
    LOCAL_DIR = ".claude/skills"

    def run(args)
      command = args.shift

      case command
      when "add", "install"      then install(args)
      when "del", "remove"       then remove(args)
      when "list"     then list
      when "version"  then puts "hitank v#{VERSION}"
      when "help", nil then help
      else
        warn "Unknown command: #{command}"
        help
        exit 1
      end
    end

    private

    def install(args)
      local = args.delete("--local")
      name = args.first

      abort "Usage: hitank add SKILL [--local]" unless name

      target = local ? LOCAL_DIR : GLOBAL_DIR
      skill_dir = File.join(target, name)

      if Dir.exist?(skill_dir)
        warn "Skill '#{name}' already installed at #{skill_dir}"
        warn "Remove it first: hitank del #{name}#{local ? ' --local' : ''}"
        exit 1
      end

      puts "Fetching skill '#{name}' from #{REPO}..."

      files = fetch_skill_files(name)
      abort "Skill '#{name}' not found in the repository." if files.empty?

      FileUtils.mkdir_p(skill_dir)

      files.each do |path, content|
        relative = path.sub("skills/#{name}/", "")
        file_path = File.join(skill_dir, relative)
        FileUtils.mkdir_p(File.dirname(file_path))
        File.write(file_path, content)
      end

      # Resolve dependencies from SKILL.md frontmatter
      skill_md_path = File.join(skill_dir, "SKILL.md")
      if File.exist?(skill_md_path)
        frontmatter = parse_frontmatter(File.read(skill_md_path))
        if frontmatter['dependencies']
          puts "Resolving dependencies..."
          Deps.resolve!(frontmatter['dependencies'])
        end
      end

      puts "Installed '#{name}' to #{skill_dir}"
      puts "Use /#{name} in Claude Code to get started."
    end

    def remove(args)
      local = args.delete("--local")
      name = args.first

      abort "Usage: hitank del SKILL [--local]" unless name

      target = local ? LOCAL_DIR : GLOBAL_DIR
      skill_dir = File.join(target, name)

      unless Dir.exist?(skill_dir)
        abort "Skill '#{name}' not found at #{skill_dir}"
      end

      FileUtils.rm_rf(skill_dir)
      puts "Removed '#{name}' from #{skill_dir}"
    end

    def list
      puts "Available skills in #{REPO}:\n\n"

      skills = fetch_skill_list
      if skills.empty?
        puts "  (none found)"
        return
      end

      skills.each do |skill|
        puts "  #{skill[:name].ljust(20)} #{skill[:description]}"
      end

      puts "\nInstall with: hitank add SKILL_NAME"
    end

    def help
      puts <<~HELP
        hitank v#{VERSION}
        Claude Code skills written in Ruby. Zero gems, zero magic.

        Commands:
          add  SKILL [--local]   Install a skill (~/.claude/skills/ by default)
          del  SKILL [--local]   Remove an installed skill
          list                   List available skills
          version                Show version
          help                   Show this help
      HELP
    end

    def fetch_skill_files(name)
      tree = fetch_github_tree
      prefix = "skills/#{name}/"

      files = {}
      tree.select { |item| item["path"].start_with?(prefix) && item["type"] == "blob" }.each do |item|
        content = fetch_github_file(item["path"])
        files[item["path"]] = content
      end
      files
    end

    def fetch_skill_list
      tree = fetch_github_tree
      skill_dirs = tree
        .select { |item| item["path"].match?(%r{^skills/[^/]+$}) && item["type"] == "tree" }
        .map { |item| item["path"].sub("skills/", "") }

      skill_dirs.map do |name|
        skill_md = tree.find { |item| item["path"] == "skills/#{name}/SKILL.md" }
        description = if skill_md
                        content = fetch_github_file(skill_md["path"])
                        extract_description(content)
                      else
                        "(no description)"
                      end
        { name: name, description: description }
      end
    end

    def parse_frontmatter(content)
      if content =~ /\A---\s*\n(.+?)\n---/m
        YAML.safe_load($1) || {}
      else
        {}
      end
    end

    def extract_description(skill_md_content)
      fm = parse_frontmatter(skill_md_content)
      fm['description'] || "(no description)"
    end

    def fetch_github_tree
      uri = URI("https://api.github.com/repos/#{REPO}/git/trees/#{BRANCH}?recursive=1")
      response = github_get(uri)
      data = JSON.parse(response.body)
      data["tree"] || []
    end

    def fetch_github_file(path)
      uri = URI("https://raw.githubusercontent.com/#{REPO}/#{BRANCH}/#{path}")
      github_get(uri).body
    end

    def github_get(uri)
      req = Net::HTTP::Get.new(uri)
      req["User-Agent"] = "hitank/#{VERSION}"
      req["Accept"] = "application/vnd.github.v3+json"

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }

      unless response.is_a?(Net::HTTPSuccess)
        abort "GitHub API error: #{response.code} #{response.message}"
      end

      response
    end
  end
end
