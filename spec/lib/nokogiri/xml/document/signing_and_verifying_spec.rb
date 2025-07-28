require 'spec_helper'

describe "signing and verifying signatures:" do
  subject do
    Nokogiri::XML(fixture('sign2-doc.xml'))
  end

  describe 'signing a document with an RSA key' do
    before { subject.sign! key: fixture('rsa.pem'), name: 'test',
             signature_alg: 'rsa-sha256', digest_alg: 'sha256'
    }

    it 'should produce a signed document' do
      expect(subject.to_s).to eql(fixture('sign2-result.xml'))
    end

    describe 'verifying the document with a single public key' do
      it 'should be valid' do
        expect(subject.verify_with(key: fixture('rsa.pub'))).to be_truthy
      end
    end

    describe 'verifying the document with a set of keys' do
      it 'should be valid' do
        expect(subject.verify_with({
          'test' => fixture('rsa.pub')
        })).to be_truthy
      end
    end
  end

  describe 'signing a document with an RSA key and X509 certificate' do
    before do
      subject.sign! key: fixture('cert/server.key.decrypted'),
                    cert: fixture('cert/server.crt'),
                    signature_alg: 'rsa-sha256',
                    digest_alg: 'sha256'
    end

    it 'should produce a signed document' do
      expect(subject.to_s).to eql(fixture('sign3-result.xml'))
    end

    describe 'verifying the document with an array of X509 certificates' do
      specify do
        expect(subject.verify_with(cert: [fixture('cert/server.crt')])).to be_truthy
      end

      it 'should verify using system certificates' do
        pending("Testing system certs requires admin privs. Read exception message in code.")
        unless subject.verify_signature
          raise <<-end_error
            Could not use system certificates to verify the signature.
            Note that this may not be a failing spec. You should copy
            or symlink the file `spec/fixtures/cert/server.crt` into
            the directory shown by running `openssl version -d`. After
            doing so, run `sudo c_rehash CERT_PATH`, where
            CERT_PATH is the same directory you copied the certificate
            into (/usr/lib/ssl/certs by default on Ubuntu). After doing
            that, run this spec again and see if it passes.
          end_error
        end
      end
    end

    describe 'verifying the document with one X509 certificate' do
      specify do
        expect(subject.verify_with(cert: fixture('cert/server.crt'))).to be_truthy
      end
    end
  end
  describe 'test all signature algorithms' do
    [ 'rsa-sha1', 'rsa-sha224', 'rsa-sha256', 'rsa-sha384', 'rsa-sha512' ].each do |signature_algorithm|
      specify "All RSA signatures work with cert signing" do
        subject.sign! key: fixture('cert/server.key.decrypted'),
          cert: fixture('cert/server.crt'),
          signature_alg: signature_algorithm,
          digest_alg: 'sha256'
      end
      specify "All RSA signatures work with bare key signing" do
        subject.sign! key: fixture('cert/server.key.decrypted'),
          name: 'test',
          signature_alg: signature_algorithm,
          digest_alg: 'sha256'
      end
    end
    [ 'ecdsa-sha1', 'ecdsa-sha224', 'ecdsa-sha256', 'ecdsa-sha384', 'ecdsa-sha512', 'dsa-sha1', 'dsa-sha256' ].each do |signature_algorithm|
      specify "All non-RSA signatures work with cert signing" do
        pending("use the right key type")
        subject.sign! key: fixture('cert/server.key.decrypted'),
          name: 'test',
          cert: fixture('cert/server.crt'),
          signature_alg: signature_algorithm,
          digest_alg: 'sha256'
      end
      specify "All non-RSA signatures work with bare key" do
        pending("use the right key type")
        subject.sign! key: fixture('cert/server.key.decrypted'),
          name: 'test',
          signature_alg: signature_algorithm,
          digest_alg: 'sha256'
      end
    end
  end
  describe 'test all digest algorithms' do
    [ 'sha1', 'sha224', 'sha256', 'sha384', 'sha512' ].each do |digest_algorithm|
      specify "All digests with cert" do
        subject.sign! key: fixture('cert/server.key.decrypted'),
          name: 'test',
          cert: fixture('cert/server.crt'),
          signature_alg: 'rsa-sha256',
          digest_alg: digest_algorithm
      end
      specify "All digests with bare key" do
        subject.sign! key: fixture('cert/server.key.decrypted'),
          name: 'test',
          signature_alg: 'rsa-sha256',
          digest_alg: digest_algorithm
      end
    end
  end
end
