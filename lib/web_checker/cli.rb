require 'thor'
require 'web_checker/workflow'
require 'eventmachine'

module WebChecker
  class CLI < Thor
    default_task :start

    desc 'start', 'Start the web-checker service'

    method_option :url,
                  type: :string,
                  required: true,
                  banner:  'Url for monitoring'

    method_option :email,
                  type: :string,
                  required: true,
                  banner:  'Email for notifications'

    method_option :delivery_method,
                  type: :string,
                  default: 'sendmail',
                  banner:  'Delivery email method'

    method_option :twilio,
                  type: :boolean,
                  default: false,
                  banner:  'Use twilio for SMS notifications'

    method_option :phone,
                  type: :string,
                  banner: 'Mobile phone number for SMS notifications'

    method_option :twilio_sid,
                  type: :string,
                  banner: 'Twilio sid value'

    method_option :twilio_token,
                  type: :string,
                  banner: 'Twilio token value'

    method_option :twilio_from,
                  type: :string,
                  banner: 'Twilio from value'

    method_option :threshold,
                  type: :array,
                  default: %w{5 10 50 100 500},
                  banner: 'Attempts threshold for warning notify'

    method_option :refresh_rate,
                  type: :numeric,
                  default: 5,
                  banner: 'Refresh rate for checking in seconds'

    def start
      trap("INT") { self.stop }

      begin
        @checker = WebChecker::Workflow.new(options)
      rescue WebChecker::NotHttpURIError, WebChecker::InvalidHostError => e
        puts "--url error. #{e.message}"
        exit
      end

      EventMachine.run do
        @checker.run
      end
    end

    no_commands do
      def stop
        @checker.cancel
        EventMachine.stop
        exit
      end
    end

  end
end