require 'spec_helper'
require 'service/notifications'

describe WebChecker::Notifications do
  context 'singleton' do
    it 'no public new' do
      expect { WebChecker::Notifications.new }.to raise_error(NoMethodError)
    end

    it 'return the same instance' do
      expect(WebChecker::Notifications.instance).to be WebChecker::Notifications.instance
    end

    it 'have :options property' do
      expect(WebChecker::Notifications.instance.respond_to? :options).to be_truthy
      expect(WebChecker::Notifications.instance.respond_to? :options=).to be_truthy
    end
  end
end