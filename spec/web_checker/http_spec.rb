require 'spec_helper'
require 'service/http'
require 'net/http'

describe WebChecker::Http do

  context 'initialize' do
    it 'raise WebChecker::NotHttpURIError if uri not http(s)' do
      expect { WebChecker::Http.new('ftp://yandex.ru') }.to raise_error(WebChecker::NotHttpURIError)
    end

    it 'raise WebChecker::InvalidHostError if uri contains invalid host' do
      expect { WebChecker::Http.new('http://yandex.fake') }.to raise_error(WebChecker::InvalidHostError)
      expect { WebChecker::Http.new('10.0.1') }.to raise_error(WebChecker::InvalidHostError)
    end
  end

  context 'accessible?' do
    it 'true for 2xx responses' do
      expect_any_instance_of(Net::HTTP).to receive(:request).and_return(Net::HTTPSuccess.new('1.1', '200', 'Ok'))
      expect(WebChecker::Http.new('http://yandex.ru').accessible?).to be_truthy
    end

    it 'handle redirects correctly' do
      expect(WebChecker::Http.new('http://yandex.ru', 0).accessible?).to be_falsy
      expect(WebChecker::Http.new('http://yandex.ru', 1).accessible?).to be_falsy
      expect(WebChecker::Http.new('http://yandex.ru', 2).accessible?).to be_truthy
    end

    it 'false for 4xx responses' do
      expect_any_instance_of(Net::HTTP).to receive(:request).and_return(Net::HTTPClientError.new('1.1', '404', 'Not found'))
      expect(WebChecker::Http.new('http://yandex.ru/fake').accessible?).to be_falsy
    end

    it 'false for 5xx responses' do
      expect_any_instance_of(Net::HTTP).to receive(:request).and_return(Net::HTTPServerError.new('1.1', '500', 'Internal Server Error'))
      expect(WebChecker::Http.new('http://yandex.ru/fake').accessible?).to be_falsy
    end

    it 'false if network down' do
      expect_any_instance_of(Net::HTTP).to receive(:connect).and_raise(SocketError)
      expect(WebChecker::Http.new('http://yandex.ru').accessible?).to be_falsy
    end
  end

end