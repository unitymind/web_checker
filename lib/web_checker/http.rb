require 'net/http'
require 'whois'

module WebChecker
  #
  # Not a HTTP URI.
  #

  class NotHttpURIError < StandardError; end
  class InvalidHostError < StandardError; end

  class Http
    def initialize(uri_str, limit = 10)
      @uri_str, @limit = uri_str, limit
      @uri_str = "http://#{@uri_str}" unless @uri_str.include?('://')
      @uri = URI(@uri_str)
      raise NotHttpURIError, "Not HTTP URI: #{@uri_str}" unless @uri.scheme.include?('http')
      raise InvalidHostError, 'Domain or host not exists' unless domain_exists?(@uri.host)
    end

    def accessible?
      return false if @limit == 0
      begin
        Net::HTTP.start(@uri.host, @uri.port, :use_ssl => @uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
          request = Net::HTTP::Get.new(@uri.request_uri)
          response = http.request(request)
          case response
            when Net::HTTPSuccess      then true
            when Net::HTTPClientError  then false
            when Net::HTTPServerError  then false
            when Net::HTTPRedirection
              location = response['location']
              unless location.include?('://')
                host_with_protocol = @uri_str[/^[^\:]+\:\/\/[^\/]+/, 0]
                location = host_with_protocol + location
              end
              self.class.new(location, @limit - 1).accessible?
            else
              false
          end
        end
      rescue SocketError
        false
      end
    end

    private
      def domain_exists?(domain)
        begin
          Whois::Client.new.lookup(domain)
        rescue Whois::ServerNotFound
          return false
        rescue Whois::ConnectionError
          return true
        end
        true
      end
  end
end
