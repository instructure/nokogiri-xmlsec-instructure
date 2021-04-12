# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xmlsec/version'

Gem::Specification.new do |spec|
  spec.name          = "nokogiri-xmlsec-instructure"
  spec.version       = Xmlsec::VERSION
  spec.authors       = ["Albert J. Wong", "Cody Cutrer"]
  spec.email         = ["awong.dev@gmail.com", "cody@instructure.com"]
  spec.description   = %q{Adds support to Ruby for encrypting, decrypting,
    signing and validating the signatures of XML documents, according to the
    [XML Encryption Syntax and Processing](http://www.w3.org/TR/xmlenc-core/)
    standard, and the [XML Signature Syntax and Processing](http://www.w3.org/TR/xmldsig-core/)
    standard by wrapping around the [xmlsec](http://www.aleksey.com/xmlsec) C
    library and adding relevant methods to `Nokogiri::XML::Document`.
    Implementation is based off nokogiri-xmlsec by Colin MacKenzie IV with
    very heavy modifications.}
  spec.summary       = %q{Wrapper around http://www.aleksey.com/xmlsec to
    support XML encryption, decryption, signing and signature validation in
    Ruby}
  spec.homepage      = "https://github.com/instructure/nokogiri-xmlsec-instructure"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.extensions = %w{ext/nokogiri_ext_xmlsec/extconf.rb}

  spec.add_dependency 'nokogiri', '>= 1.11.2'

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-rake"
end
