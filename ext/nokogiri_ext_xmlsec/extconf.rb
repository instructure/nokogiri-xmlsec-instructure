# frozen_string_literal: true

require "mkmf"
require "nokogiri"

abort unless pkg_config("xmlsec1")
append_cflags("-fvisibility=hidden")

abort unless find_header("nokogiri.h", *Dir["#{Gem.loaded_specs["nokogiri"].full_gem_path}/ext/*"])

# We reference symbols out of nokogiri but don't link directly against it
append_ldflags(["-Wl", "-undefined,dynamic_lookup"])

create_makefile("nokogiri_ext_xmlsec")
