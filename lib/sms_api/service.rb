require 'net/http'
require 'uri'

module SmsAPI
  class Service
    attr_accessor :message
    attr_reader :receiver

    def initialize(receiver)
      @receiver = receiver
    end

    def send_sms
      uri = URI.parse('https://api.smsapi.pl/sms.do')
      Net::HTTP.post_form(uri, headers)
    end

    private

    def headers
      {
        username: ENV['SMSAPI_USER'],
        password: ENV['SMSAPI_KEY'],
        from: 'Eco',
        to: receiver,
        message: message,
        encoding: 'utf-8',
        format: 'json'
      }
    end
  end
end
