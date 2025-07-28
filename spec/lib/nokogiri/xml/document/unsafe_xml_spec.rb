require 'spec_helper'

describe "unsafe xml guards:" do
  context "XML Signature URI" do
    it "does not allow file path URIs in signing references" do
      doc = Nokogiri::XML(fixture('hate.xml'))
      expect{
        doc.sign!(cert: fixture('cert/server.crt'),
                  key: fixture('cert/server.key.decrypted'),
                  name: 'test',
                  signature_alg: 'rsa-sha256',
                  digest_alg: 'sha256',
                  uri: "#{fixture_path("pwned.xml")}")}.to raise_error(
          XMLSec::SigningError, /signature failed/)
    end

    it "does not allow file:// URIs in signing references" do
      doc = Nokogiri::XML(fixture('hate.xml'))
      expect{
        doc.sign!(cert: fixture('cert/server.crt'),
                  key: fixture('cert/server.key.decrypted'),
                  name: 'test',
                  signature_alg: 'rsa-sha256',
                  digest_alg: 'sha256',
                  uri: "file://#{fixture_path("pwned.xml")}")}.to raise_error(
          XMLSec::SigningError, /signature failed/)
    end

    it "does not allow network URIs in signing references" do
      doc = Nokogiri::XML(fixture('hate.xml'))
      expect{
        doc.sign!(cert: fixture('cert/server.crt'),
                  key: fixture('cert/server.key.decrypted'),
                  name: 'test',
                  signature_alg: 'rsa-sha256',
                  digest_alg: 'sha256',
                  uri: "http://www.w3.org/2001/XMLSchema.xsd")}.to raise_error(
          XMLSec::SigningError, /signature failed/)
    end

    it "does allow empty signing references" do
      doc = Nokogiri::XML(fixture('hate.xml'))
      doc.sign!(cert: fixture('cert/server.crt'),
                key: fixture('cert/server.key.decrypted'),
                name: 'test',
                signature_alg: 'rsa-sha256',
                digest_alg: 'sha256',
                uri: "")
    end

    it "does allow same document signing references" do
      doc = Nokogiri::XML(fixture('hate.xml'))
      doc.sign!(cert: fixture('cert/server.crt'),
                key: fixture('cert/server.key.decrypted'),
                name: 'test',
                signature_alg: 'rsa-sha256',
                digest_alg: 'sha256',
                uri: "#some_frackin_id")
    end
  end
end
