# frozen_string_literal: true

describe "encryption and decryption" do # rubocop:disable RSpec/DescribeClass
  subject do
    Nokogiri::XML(fixture("sign2-doc.xml"))
  end

  %w[aes128-cbc aes192-cbc aes256-cbc tripledes-cbc].each do |block_encryption|
    %w[rsa-1_5 rsa-oaep-mgf1p].each do |key_transport| # rubocop:disable Performance/CollectionLiteralInLoop
      describe "encrypting with an RSA public key with #{block_encryption} #{key_transport}" do
        let(:original) { subject.to_s }

        before do
          original
          subject.encrypt!(
            key: fixture("rsa.pub"),
            name: "test",
            block_encryption:,
            key_transport:
          )
        end

        # it generates a new key every time so will never match the fixture
        specify { expect(subject.to_s == original).to be_falsey }
        specify { expect(subject.to_s =~ /Hello.*World/i).to be_falsey }
        # specify { subject.to_s.should == fixture('encrypt2-result.xml') }

        describe "decrypting with the RSA private key" do
          before do
            subject.decrypt! key: fixture("rsa.pem")
          end

          specify { expect(subject.to_s == fixture("sign2-doc.xml")).to be_truthy }
        end
      end
    end
  end

  it "encrypts a single element" do
    doc = subject
    original = doc.to_s
    node = doc.at_xpath("env:Envelope/env:Data", "env" => "urn:envelope")
    node.encrypt_with(key: fixture("rsa.pub"), block_encryption: "aes128-cbc", key_transport: "rsa-1_5")
    expect(doc.root.name).to eq "Envelope"
    expect(doc.root.element_children.first.name).to eq "EncryptedData"
    encrypted_data = doc.root.element_children.first
    encrypted_data.decrypt_with(key: fixture("rsa.pem"))
    expect(doc.to_s).to eq original
  end

  it "inserts a certificate" do
    doc = subject
    doc.encrypt!(key: fixture("cert/server.key.decrypted"),
                 cert: fixture("cert/server.crt"),
                 block_encryption: "aes128-cbc",
                 key_transport: "rsa-1_5")
    expect(doc.to_s).to match(/X509Data/)
    expect(doc.to_s).not_to match(/X509Data></)
  end
end
