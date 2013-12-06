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
    @attempts = @attempts.to_i
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
      raise "There was a problem with the installation. Please file a bug report at bugreports.cgifederal.com" if @attempts > 0
      puts "Installing Ruby...this will take upto 15 minutes...be patient"
      @attempts += 1
      install_ruby
      sleep 5
      puts "Ruby is installed" if ruby_installed?
      self.install(false)
    end
    #download_and_install(editor)
  end

  def self.ruby_installed?
    begin
      @rubyversion = run("ruby -v")
      if @rubyversion.match('1.9.3') 
        true
      elsif @rubyversion.match('ruby')
        raise "You seem to have #{@rubyversion} installed \n. Please uninstall it and restart this installer"
      else
        false
      end
    rescue 
      nil
    end
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

  def self.install_ruby
    #run download(binary), true
    file = File.join(File.dirname(__FILE__), 'railsinstaller.exe')
    run file rescue nil
  end

  def self.install_framework
    run('gem install cms_automation', true)
  end


  def self.run(command, without_output=false)
    command = "#{command} >nul 2>&1" if without_output
    `#{command}`
  end

  def self.ruby_installed_message
    correct_version = <<-message
     It seems you already have ruby #{@rubyversion} installed. 
     Skipping installation of Ruby
     If you would like to reinstall ruby with this installer, uninstall existing ruby installation
     and run this installer again
    message

    incorrect_version = "It seems that you have a different version of ruby installed. Please uninstall the current version \n
    and rerun the installer"

    @rubyversion.match('1.9.3') ? correct_version : incorrect_version
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



