require 'json'

module Hitank
  module Deps
    extend self

    def detect_os
      case RUBY_PLATFORM
      when /darwin/
        :macos
      when /linux/
        return :debian if File.exist?('/etc/debian_version')
        return :fedora if File.exist?('/etc/fedora-release') || File.exist?('/etc/redhat-release')
        return :arch   if File.exist?('/etc/arch-release')
        :unknown
      else
        :unknown
      end
    end

    def command_exists?(cmd)
      system("command -v #{cmd} > /dev/null 2>&1")
    end

    def resolve!(dependencies)
      return unless dependencies

      if dependencies['npm']
        ensure_node!
        dependencies['npm'].each { |pkg| ensure_npm_package!(pkg) }
      end
    end

    private

    def ensure_node!
      return if command_exists?('node') && command_exists?('npm')

      os = detect_os
      puts "Node.js not found. Installing for #{os}..."

      case os
      when :macos  then install_node_macos
      when :debian then install_node_debian
      when :fedora then install_node_fedora
      when :arch   then install_node_arch
      else
        abort <<~MSG
          Could not detect your OS. Please install Node.js manually:
            https://nodejs.org/en/download
          Then run `hitank install` again.
        MSG
      end

      unless command_exists?('node')
        abort "Failed to install Node.js. Please install it manually and try again."
      end

      puts "Node.js installed successfully."
    end

    def ensure_npm_package!(package)
      bin_name = package.split('/').last.sub(/^cli$/, package.split('/').first.tr('@', ''))
      return if command_exists?(bin_name)

      puts "Installing #{package}..."
      unless system("npm install -g #{package} > /dev/null 2>&1")
        abort "Failed to install #{package}. Try manually: npm install -g #{package}"
      end

      puts "#{package} installed successfully."
    end

    def install_node_macos
      unless command_exists?('brew')
        puts "Homebrew not found. Installing Homebrew..."
        system('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
        abort "Failed to install Homebrew. Please install Node.js manually." unless command_exists?('brew')
      end
      system("brew install node")
    end

    def install_node_debian
      system('curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - > /dev/null 2>&1 && sudo apt-get install -y nodejs > /dev/null 2>&1')
    end

    def install_node_fedora
      system('curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash - > /dev/null 2>&1 && sudo yum install -y nodejs > /dev/null 2>&1')
    end

    def install_node_arch
      system("sudo pacman -S --noconfirm nodejs npm > /dev/null 2>&1")
    end
  end
end
