require 'web_checker/workflow'
require 'web_checker/notifications'

describe WebChecker::Workflow do

  options = {
    "twilio" => false,
    "url" => "http://yandex.ru/",
    "email" => "devops@cleawing.com",
    "threshold"=>["5", "10", "50", "100", "500"]
  }


  let(:workflow) { WebChecker::Workflow.new(options) }


  it 'call notify_broken 5 times if totally 404' do
    max_attempts = options['threshold'].map(&:to_i).max
    expect(workflow.checker).to receive(:accessible?).and_return(false).exactly(max_attempts + 100).times
    expect(WebChecker::Notifications.instance).to receive(:notify_broken).exactly(options['threshold'].size).times
    (max_attempts + 100).times { workflow.run }
    expect(workflow.attempts).to eql (max_attempts + 100)
  end

  it 'call notify once if attempts > 0 and url is OK' do
    workflow.instance_variable_set(:@attempts, 1)
    expect(workflow.checker).to receive(:accessible?).and_return(true).twice
    expect(WebChecker::Notifications.instance).to receive(:notify).once
    2.times { workflow.run }
  end
end