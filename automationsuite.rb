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
class Installer

  def self.install(old_installation=true)
    if ruby_installed?
      puts ruby_installed_message if old_installation
      if framework_installed?
        puts framework_installed_message
      else
        puts "Installing CMS Automation Framework...this will take upto 5 minutes...be patient!"
        install_framework
        framework_post_install
      end
    else
      puts "Installing Ruby...this will take upto 15 minutes...be patient"
      download_and_install(ruby)
      self.install(false)
    end
    #download_and_install(editor)
  end

  def self.ruby_installed?
    @ruby_path = run("where ruby")
    !@ruby_path.to_s.empty?
  end

  def self.framework_installed?
    #begin
      #Gem::Specification.find_by_name('cms_automation')
    #rescue Gem::LoadError
      #false
    #end
    begin
      result = run('automationsuite testinstall')
      !(result.empty? || result.nil?)
    rescue 
      false
    end
  end

  def self.download_and_install(binary)
    run download(binary, true)
  end

  def self.download(url)
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

  def self.install_framework
    run('gem install cms_automation', true)
  end


  def self.run(command, without_output=false)
    command = "#{command} >nul 2>&1" if without_output
    `#{command}`
  end

  def self.ruby_installed_message
    <<-message
     You already have ruby installed at #{@ruby_path}. Please make sure it is version 1.9.3 by running `ruby -v`
     Skipping installation of Ruby
     If you would like to reinstall ruby with this installer, uninstall existing ruby installation
     and run this installer again
    message
  end

  def self.framework_installed_message
    <<-message
       You already have the CMS Automation Framework installed.
       Skipping installation of the framework.
       If you would like to reinstall the framework, uninstall it first. 
       You can find the instructions here: instructions.url
    message
  end

  def self.framework_post_install
    sleep 5
    if framework_installed?
      puts "Successfully installed the Automation Framework!!"
    else
      puts "Could not install the gem correctly"
    end
  end

  def self.ruby
    'http://sourceforge.net/projects/railsinstaller/files/RailsInstaller%20Windows/RailsInstaller-Windows-2.2.1.exe/download'
  end

  def self.editor
    'http://editorurl.com'
  end
end

Installer.install



