require "xmlsec/version"
require 'nokogiri'
require 'ext/xmlsecrb'

class Nokogiri::XML::Document
  # Signs this document, and then returns it.
  #
  # Examples:
  #
  #     doc.sign! rsa: 'rsa-private-key'
  #     doc.sign! rsa: 'rsa-private-key', name: 'key-name'
  #     doc.sign! x509: 'x509 certificate', rsa: 'cert private key'
  #     doc.sign! x509: 'x509 certificate', rsa: 'cert private key',
  #               name: 'key-name'
  #
  # You can also use `:cert` or `:certificate` as aliases for `:x509`.
  #
  def sign! opts
    if (cert = opts[:x509]) || (cert = opts[:cert]) || (cert = opts[:certificate])
      raise "need a private :rsa key" unless opts[:rsa]
      _sign_x509 opts[:name].to_s, opts[:rsa], cert
    elsif opts[:rsa]
      _sign_rsa opts[:name].to_s, opts[:rsa]
    else
      raise "No signing key"
    end
    self
  end

  # Verifies the signature on the current document.
  #
  # Returns `true` if the signature is valid, `false` otherwise.
  # 
  # Examples:
  #
  #     # Try to validate with the given public or private key
  #     doc.verify_with rsa: 'rsa-key'
  #
  #     # Try to validate with a set of keys. It will try to match
  #     # based on the contents of the `KeyName` element.
  #     doc.verify_with({
  #       'key-name'         => 'x509 certificate',
  #       'another-key-name' => 'rsa-public-key'
  #     })
  #     
  #     # Try to validate with a trusted certificate
  #     doc.verify_with(x509: 'certificate')
  #
  #     # Try to validate with a set of certificates, any one of which
  #     # can match
  #     doc.verify_with(x509: ['cert1', 'cert2'])
  #
  # You can also use `:cert` or `:certificate` or `:certs` or
  # `:certificates` as aliases for `:x509`.
  #
  def verify_with opts_or_keys
    if (certs = opts_or_keys[:x509]) ||
       (certs = opts_or_keys[:cert]) ||
       (certs = opts_or_keys[:certs]) ||
       (certs = opts_or_keys[:certificate]) ||
       (certs = opts_or_keys[:certificates])
      certs = [certs] unless certs.kind_of?(Array)
      verify_with_certificates certs
    elsif opts_or_keys[:rsa]
      verify_with_rsa_key opts_or_keys[:rsa]
    else
      verify_with_named_keys opts_or_keys
    end
  end

  # Attempts to verify the signature of this document using only certificates
  # installed on the system. This is equivalent to calling
  # `verify_with certificates: []` (that is, an empty array).
  #
  def verify_signature
    verify_with_certificates []
  end
end
