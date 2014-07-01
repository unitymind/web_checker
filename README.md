# WebChecker

A simple service for checking a availability of web resource

## Installation

Add this line to your application's Gemfile:

    gem 'web_checker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install web_checker

## Usage

    web_checker start --email=Email for notifications --url=Url for monitoring

    Options:
      --url=Url for monitoring
      --email=Email for notifications
      [--delivery-method=Delivery email method]
                                                              # Default: sendmail
      [--twilio=Use twilio for SMS notifications], [--no-twilio]
      [--phone=Mobile phone number for SMS notifications]
      [--twilio-sid=Twilio sid value]
      [--twilio-token=Twilio token value]
      [--twilio-from=Twilio from value]
      [--threshold=Attempts threshold for notifications]
                                                              # Default: ["5", "10", "50", "100", "500"]
      [--refresh-rate=Refresh rate for checking in seconds]
                                                              # Default: 5

## Contributing

1. Fork it ( https://github.com/unitymind/web_checker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
