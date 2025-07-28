# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/extensiontask"
require "rspec/core/rake_task"

Rake::ExtensionTask.new("nokogiri_ext_xmlsec")

RSpec::Core::RakeTask.new :rspec

desc "clean out build files"
task :clean do
  rm_rf File.expand_path("tmp", __dir__)
end

task default: %i[clean compile rspec]
