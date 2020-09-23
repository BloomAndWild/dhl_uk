# DhlUk

Ruby wrapper for DHL UK API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "dhl_uk", branch: "master", github: "BloomAndWild/dhl_uk"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dhl_uk

## Usage

### Configure client

```ruby
DhlUk::Client.configure do |config|
  config.base_url = ENV.fetch('DHL_UK_BASE_URL')
  config.api_key = ENV.fetch('DHL_UK_API_KEY')
  config.username = ENV.fetch('DHL_UK_USERNAME')
  config.password = ENV.fetch('DHL_UK_PASSWORD')

  logger = Logger.new(STDERR)
  logger.level = :debug
  config.logger = logger
end
```

### SSO Authentication

Authenticate with SSO Authentication endpoint:

```ruby
DhlUk::AuthToken.new.token
```

If successful, it will return an authentication token for use in further requests.

## Running specs

To run the specs, add your sandbox credentials to your dev env:
```
DHL_UK_BASE_URL=https://services.qa.dhlparcel.co.uk
DHL_UK_API_KEY=
DHL_UK_USERNAME=
DHL_UK_PASSWORD=
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BloomAndWild/dhl_uk.
