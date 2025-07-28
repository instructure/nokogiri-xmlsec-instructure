# frozen_string_literal: true

source "https://rubygems.org"

plugin "bundler-multilock", "~> 1.4"
return unless Plugin.installed?("bundler-multilock")

Plugin.send(:load_plugin, "bundler-multilock")

gemspec

gem "debug", "~> 1.11"
gem "rake", "~> 13.3"
gem "rake-compiler", "~> 1.3"
gem "rspec", "~> 3.13"
gem "rubocop-inst", "~> 1.2"
gem "rubocop-rake", "~> 0.7"
gem "rubocop-rspec", "~> 3.6"

lockfile do
  gem "nokogiri", "~> 1.18.9"
end

lockfile "nokogiri-1.17" do
  gem "nokogiri", "~> 1.17.2"
end

lockfile "nokogiri-1.16" do
  gem "nokogiri", "~> 1.16.8"
end

lockfile "nokogiri-1.15" do
  gem "nokogiri", "~> 1.15.7"
end

lockfile "nokogiri-1.14" do
  gem "nokogiri", "~> 1.14.5"
end

lockfile "nokogiri-1.13" do
  gem "nokogiri", "~> 1.13.10"
end
