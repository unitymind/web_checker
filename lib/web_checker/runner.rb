require 'service/http'
require 'service/notifications'
require 'eventmachine'

module WebChecker
  class Runner
    def initialize(options)
      @options = options.dup
      @options['threshold'] = @options['threshold'].map(&:to_i)
      @checker = WebChecker::Http.new(options['url'])
      @attempts = 0
    end

    def run
      trap("INT") { EM.stop }

      EM.run do
        EM.add_timer(@options['refresh_rate']) do
          make_check
        end
      end

    end

    def make_check
      if @checker.accessible?
        WebChecker::Notifications.instance.notify if @attempts > 0
        @attempts = 0
      else
        @attempts += 1
        if @options['threshold'].include?(@attempts)
          WebChecker::Notifications.instance.notify_broken(@attempts)
        end
      end
      EM.add_timer(@options['refresh_rate']) do
        make_check
      end
    end
  end
end