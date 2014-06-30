require 'singleton'
require 'twilio-ruby'
require 'mail'
require 'socket'

module WebChecker
  class Notifications
    include Singleton
    attr_accessor :options

    def setup(options)
      @options = options
      @twilio = @options['twilio'] ? Twilio::REST::Client.new(@options['twilio_sid'], @options['twilio_token']) : nil
    end

    def notify
      message = "Your url #{@options['url']} is active now"
      results = []
      results.push(notify_via_email(message))
      results.push(notify_via_twilio(message)) if @twilio
      results.include?(false) ? false : true
    end

    def notify_broken(attempts)
      results = []
      results.push(notify_via_email(build_broken_message(attempts)))
      results.push(notify_via_twilio(build_broken_message(attempts))) if @twilio
      results.include?(false) ? false : true
    end

    private
      def notify_via_email(message)
        begin
          mail = Mail.new
          mail.body = message
          mail.from = "no-reply@#{Socket.gethostname}"
          mail.to = @options['email']
          mail.subject = "[Web checker] notify about #{@options['url']}"

          mail.delivery_method @options['delivery_method'].to_sym
          mail.deliver
          true
        rescue StandardError
          false
        end
      end

      def notify_via_twilio(message)
        begin
          @twilio.account.messages.create({
              :from => @options['twilio_from'],
              :to => @options['phone'],
              :body => message
          })
          true
        rescue StandardError
          false
        end
      end

      def build_broken_message(attempts)
        "Your url #{@options['url']} is broken after #{attempts} attempts"
      end
  end
end