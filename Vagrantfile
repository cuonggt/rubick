# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'
require 'yaml'

VAGRANTFILE_API_VERSION ||= "2"
confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))

rubickYamlPath = confDir + "/Rubick.yaml"
rubickJsonPath = confDir + "/Rubick.json"
afterScriptPath = confDir + "/after.sh"
aliasesPath = confDir + "/aliases"

require File.expand_path(File.dirname(__FILE__) + '/scripts/rubick.rb')

Vagrant.require_version '>= 1.9.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    if File.exist? aliasesPath then
        config.vm.provision "file", source: aliasesPath, destination: "/tmp/bash_aliases"
        config.vm.provision "shell" do |s|
            s.inline = "awk '{ sub(\"\r$\", \"\"); print }' /tmp/bash_aliases > /home/vagrant/.bash_aliases"
        end
    end

    if File.exist? rubickYamlPath then
        settings = YAML::load(File.read(rubickYamlPath))
    elsif File.exist? rubickJsonPath then
        settings = JSON.parse(File.read(rubickJsonPath))
    else
        abort "Rubick settings file not found in #{confDir}"
    end

    Rubick.configure(config, settings)

    if File.exist? afterScriptPath then
        config.vm.provision "shell", path: afterScriptPath, privileged: false
    end

    if defined? VagrantPlugins::HostsUpdater
        config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
    end
end
