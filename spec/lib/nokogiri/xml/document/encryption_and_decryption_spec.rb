require 'spec_helper'

describe "encryption and decryption:" do
  subject do
    Nokogiri::XML(fixture('sign2-doc.xml'))
  end

  [ 'aes128-cbc', 'aes192-cbc', 'aes256-cbc', 'tripledes-cbc' ].each do |block_encryption|
    [ 'rsa-1_5', 'rsa-oaep-mgf1p' ].each do |key_transport|
      describe "encrypting with an RSA public key with #{block_encryption} #{key_transport}" do
        before do
          @original = subject.to_s
          subject.encrypt!(
            key: fixture('rsa.pub'), name: 'test',
            block_encryption: block_encryption, key_transport: key_transport)
        end

        # it generates a new key every time so will never match the fixture
        specify { expect(subject.to_s == @original).to be_falsey }
        specify { expect(subject.to_s =~ /Hello.*World/i).to be_falsey }
        # specify { subject.to_s.should == fixture('encrypt2-result.xml') }

        describe 'decrypting with the RSA private key' do
          before do
            subject.decrypt! key: fixture('rsa.pem')
          end

          specify { expect(subject.to_s == fixture('sign2-doc.xml')).to be_truthy }
        end
      end
    end
  end

  it "encrypts a single element" do
    doc = subject
    original = doc.to_s
    node = doc.at_xpath('env:Envelope/env:Data', 'env' => 'urn:envelope')
    node.encrypt_with(key: fixture('rsa.pub'), block_encryption: 'aes128-cbc', key_transport: 'rsa-1_5')
    expect(doc.root.name).to eq 'Envelope'
    expect(doc.root.element_children.first.name).to eq 'EncryptedData'
    encrypted_data = doc.root.element_children.first
    encrypted_data.decrypt_with(key: fixture('rsa.pem'))
    expect(doc.to_s).to eq original
  end
end
