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

### CreateShipment

The payload requirements are given in [DHL API documentation](https://drive.google.com/file/d/1WYJi5p43L633yailTW1Mbyo7BhZGdYbZ/view)
pp. 27-34, and include (as well as the delivery address, and sundry information):

```ruby
      {
        "username": ENV['DHL_UK_USERNAME'],
        "authenticationToken": "<AUTH_TOKEN>",
        "accountNumber": ENV['DHL_UK_ACCOUNT'],
        "collectionInfo": {
          "collectionJobNumber": "",
          "collectionDate": "2020-09-30"
        },
        "labelFormat": "PDF200dpi6x4",
        ...etc
      }
```
To make the request:
```ruby
DhlUk::Operations::CreateShipment.new(payload: payload).execute
```
If successful, it will return the booking reference and labels in the requested format:
```ruby
{
    "identifiers": [
        {
            "identifierType": "consignmentNumber",
            "identifierValue": "41150120000003"
        }
    ],
    "labels": ["pdf_data"]
}
```
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
