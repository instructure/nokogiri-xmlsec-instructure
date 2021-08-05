require 'mkmf'

def barf message = 'dependencies not met'
  raise message
end

barf unless have_header('ruby.h')

pkg_config('xmlsec1')
$CFLAGS << " " + `bash xmlsec1-config  --cflags`.strip
$CFLAGS << " -fvisibility=hidden"

if $CFLAGS =~ /\-DXMLSEC_CRYPTO=\\\\\\"openssl\\\\\\"/
puts "Changing escaping: #{$CFLAGS}"
  $CFLAGS['-DXMLSEC_CRYPTO=\\\\\\"openssl\\\\\\"'] =
    '-DXMLSEC_CRYPTO=\\"openssl\\"'
end

if $CFLAGS =~ /\-DXMLSEC_CRYPTO="openssl"/
puts "Ensure we escaping: #{$CFLAGS}"
  $CFLAGS['-DXMLSEC_CRYPTO="openssl"'] =
  '-DXMLSEC_CRYPTO=\\"openssl\\"'
end

puts "Clfags: #{$CFLAGS}"
$libs = `bash xmlsec1-config  --libs`.strip
create_makefile('nokogiri_ext_xmlsec')
