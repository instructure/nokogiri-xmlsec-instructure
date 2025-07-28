# frozen_string_literal: true

require "xmlsec/version"
require "nokogiri"
require "nokogiri_ext_xmlsec"

module Nokogiri
  module XML
    class Document
      def sign!(opts)
        root.sign! opts
        self
      end

      # Verifies the signature on the current document.
      #
      # Returns `true` if the signature is valid, `false` otherwise.
      #
      # Examples:
      #
      #     # Try to validate with the given public or private key
      #     doc.verify_with key: 'rsa-key'
      #
      #     # Try to validate with a set of keys. It will try to match
      #     # based on the contents of the `KeyName` element.
      #     doc.verify_with({
      #       'key-name'         => 'x509 certificate',
      #       'another-key-name' => 'rsa-public-key'
      #     })
      #
      #     # Try to validate with a trusted certificate
      #     doc.verify_with(cert: 'certificate')
      #
      #     # Try to validate with a set of certificates, any one of which
      #     # can match
      #     doc.verify_with(certs: ['cert1', 'cert2'])
      #
      #     # Validate the signature, checking the certificate validity as of
      #     # a certain time (anything that's convertible to an integer, such as a Time)
      #     doc.verify_with(cert: 'certificate', verification_time: message_creation_timestamp)
      #
      #     # Validate the signature, but don't validate that the certificate is valid,
      #     # or has a full trust chain
      #     doc.verify_with(cert: 'certificate', verify_certificates: false)
      #
      def verify_with(opts_or_keys)
        first_signature = root.at_xpath("//ds:Signature", "ds" => "http://www.w3.org/2000/09/xmldsig#")
        raise XMLSec::VerificationError("start node not found") unless first_signature

        first_signature.verify_with(opts_or_keys)
      end

      # Attempts to verify the signature of this document using only certificates
      # installed on the system. This is equivalent to calling
      # `verify_with certificates: []` (that is, an empty array).
      #
      def verify_signature
        verify_with(certs: [])
      end

      # Encrypts the current document, then returns it.
      #
      # Examples:
      #
      #     # encrypt with a public key and optional key name
      #     doc.encrypt! key: 'public-key', name: 'name'
      #
      def encrypt!(key:, name: nil, **)
        root.encrypt_with(key:, name:, **)
        self
      end

      # Decrypts the current document, then returns it.
      #
      # Examples:
      #
      #     # decrypt with a specific private key
      #     doc.decrypt! key: 'private-key'
      #     # pass the key as an OpenSSL PKey object
      #     doc.decrypt! key: OpenSSL::PKey.read('private-key')
      #
      def decrypt!(opts)
        first_encrypted_node = root.at_xpath("//xenc:EncryptedData", "xenc" => "http://www.w3.org/2001/04/xmlenc#")
        raise XMLSec::DecryptionError("start node not found") unless first_encrypted_node

        first_encrypted_node.decrypt_with opts
        self
      end
    end
  end
end

module Nokogiri
  module XML
    class Node
      def encrypt_with(key:, name: nil, **opts)
        raise ArgumentError("public :key is required for encryption") unless key

        encrypt_with_key(name, key, opts)
      end

      def decrypt_with(opts)
        raise "inadequate options specified for decryption" unless opts[:key]

        parent = self.parent
        previous = self.previous
        key = opts[:key]
        key = key.to_pem if key.respond_to?(:to_pem)
        decrypt_with_key(opts[:name].to_s, key)
        previous ? previous.next : parent.children.first
      end
    end
  end
end
