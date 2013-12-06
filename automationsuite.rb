#!/usr/bin/env ruby

#This one click installer installs the following:
# 1. RailsInstaller
# 2. CMS Automation Gem
# 3. Gherkin Editor


## Check if ruby is installed
# tell user they have ruby installed so skipping Rails installer
#
# Check if cms_automation is installed
# tell user they have gem installed so skipping its installation
#
# Install Gherkin Editor
require 'net/http'
require 'FileUtils'
class Installer

  def install(old_installation=true)
    if ruby_installed?
      puts ruby_installed_message if old_installation
      if framework_installed?
        puts framework_installed_message
      else
        install_framework
      end
    else
      download_and_install(ruby)
      self.install(false)
    end
    #download_and_install(editor)
  end

  def ruby_installed?
    ruby_path = run("where ruby")
    !ruby_path.to_s.empty?
  end

  def framework_installed?
    load_gem = run("gem 'cms_automation'")
    !load_gem.to_s.empty?
  end

  def download_and_install(binary)
    run download(binary_url)
  end

  def download(url)
    uri = URI.parse(url)
    pwd = run('cd')
    name = uri.host =~ /rails/ ? 'railsinstaller.exe' : 'cms_automation.gem'
    path = File.join(pwd, 'Downloads', name )
    Net::HTTP.start(uri.host) do |http|
      resp = http.get(uri.path)
      open(path, "wb") do |file|
        file.write(resp.body)
      end
    end
    puts "Done."
  end


  def run(command)
    `#{command}`
  end

  def ruby_installed_message
    <<-message
     You already have ruby installed at #{ruby_path}.
     Skipping installation of Rails Installer.
     If you would like to reinstall ruby with this installer, uninstall existing ruby installation
     and run this installer again
    message
  end

  def framework_installed_message
    <<-message
       You already have the CMS Automation Framework installed.
       Skipping installation of the framework.
       If you would like to reinstall the framework, uninstall it first. 
       You can find the instructions here: instructions.url
    message
  end

  def ruby
    'http://sourceforge.net/projects/railsinstaller/files/RailsInstaller%20Windows/RailsInstaller-Windows-2.2.1.exe/download'
  end

  def editor
    'http://editorurl.com'
  end
end

Installer.install


