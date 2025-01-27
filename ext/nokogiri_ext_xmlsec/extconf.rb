require 'mkmf'
require 'nokogiri'

def barf message = 'dependencies not met'
  raise message
end

barf unless have_header('ruby.h')

pkg_config('xmlsec1')
$CFLAGS << " " + `xmlsec1-config  --cflags`.strip
$CFLAGS << " -fvisibility=hidden"

$CFLAGS << Dir[Gem.loaded_specs['nokogiri'].full_gem_path + "/ext/*"].map { |dir| " -I#{dir}"}.join("")

puts "Cflags: #{$CFLAGS}"
$libs = `xmlsec1-config  --libs`.strip

# We reference symbols out of nokogiri but don't link directly against it
$LDFLAGS << ' -Wl,-undefined,dynamic_lookup'

create_makefile('nokogiri_ext_xmlsec')
