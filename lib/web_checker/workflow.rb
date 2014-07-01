require 'web_checker/http'
require 'web_checker/notifications'
require 'eventmachine'

module WebChecker
  class Workflow
    attr_reader :checker, :attempts

    def initialize(options)
      @options = options.dup
      WebChecker::Notifications.instance.setup(@options)
      @options['threshold'] = @options['threshold'].map(&:to_i)
      @checker = WebChecker::Http.new(options['url'])
      @attempts = 0
    end

    def run
      if @checker.accessible?
        WebChecker::Notifications.instance.notify if @attempts > 0
        @attempts = 0
      else
        @attempts += 1
        if @options['threshold'].include?(@attempts)
          WebChecker::Notifications.instance.notify_broken(@attempts)
        end
      end

      if EventMachine.reactor_running?
        @timer = EventMachine.add_timer(@options['refresh_rate']) do
          run
        end
      end
    end

    def cancel
      EventMachine.cancel_timer(@timer) if self.instance_variable_defined?(:@timer) && EventMachine.reactor_running?
    end
  end
end