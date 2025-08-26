# frozen_string_literal: true

require_relative "lib/xmlsec/version"

Gem::Specification.new do |spec|
  spec.name          = "nokogiri-xmlsec-instructure"
  spec.version       = Xmlsec::VERSION
  spec.authors       = ["Albert J. Wong", "Cody Cutrer"]
  spec.email         = ["awong.dev@gmail.com", "cody@instructure.com"]
  spec.description   = 'Adds support to Ruby for encrypting, decrypting,
    signing and validating the signatures of XML documents, according to the
    [XML Encryption Syntax and Processing](http://www.w3.org/TR/xmlenc-core/)
    standard, and the [XML Signature Syntax and Processing](http://www.w3.org/TR/xmldsig-core/)
    standard by wrapping around the [xmlsec](http://www.aleksey.com/xmlsec) C
    library and adding relevant methods to `Nokogiri::XML::Document`.
    Implementation is based off nokogiri-xmlsec by Colin MacKenzie IV with
    very heavy modifications.'
  spec.summary       = 'Wrapper around http://www.aleksey.com/xmlsec to
    support XML encryption, decryption, signing and signature validation in
    Ruby'
  spec.homepage      = "https://github.com/instructure/nokogiri-xmlsec-instructure"
  spec.license       = "MIT"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["{exe,ext,lib}/**/*.{c,h,rb}"]
  spec.extensions = %w[ext/nokogiri_ext_xmlsec/extconf.rb]

  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "nokogiri", "~> 1.13"
end
