require 'web_checker/notifications'
require 'mail'

describe WebChecker::Notifications do
  Mail.defaults do
    delivery_method :test
  end

  options =
    {
        "twilio"=>true,
        "url"=>"http://yandex.ru/",
        "email"=>"devops@cleawing.com",
        "phone"=>ENV['TWILIO_PHONE'],
        "twilio_sid"=>ENV['TWILIO_SID'],
        "twilio_token"=>ENV['TWILIO_TOKEN'],
        "twilio_from"=>ENV['TWILIO_FROM']
    }

  context 'singleton' do
    it 'no public new' do
      expect { WebChecker::Notifications.new }.to raise_error(NoMethodError)
    end

    it 'return the same instance' do
      expect(WebChecker::Notifications.instance).to be WebChecker::Notifications.instance
    end
  end

  context 'setup' do
    it 'check setup of twilio client' do
      WebChecker::Notifications.instance.setup(options)
      expect(WebChecker::Notifications.instance.instance_variable_get(:@twilio)).to be_truthy
      WebChecker::Notifications.instance.setup(options.merge({"twilio" => false}))
      expect(WebChecker::Notifications.instance.instance_variable_get(:@twilio)).to be_falsey
    end

  end

  context 'notify' do
    before(:all) do
      WebChecker::Notifications.instance.setup(options)
    end

    before(:each) do
      Mail::TestMailer.deliveries.clear
    end

    it 'should sent mail and sms' do
      expect(Mail::TestMailer.deliveries.length).to eql 0
      expect(WebChecker::Notifications.instance.twilio.account.messages).to receive(:create).twice
      expect(WebChecker::Notifications.instance.notify).to be_truthy
      expect(Mail::TestMailer.deliveries.length).to eql 1
      expect(WebChecker::Notifications.instance.notify_broken(5)).to be_truthy
      expect(Mail::TestMailer.deliveries.length).to eql 2
    end

  end
end