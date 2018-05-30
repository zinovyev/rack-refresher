# rack-refresher

Rack middleware for authomatic page refresh

# About

Refresh the content of your page with a given interval

# Installation

```bash

  gem install rack-refresher

```

# Set Up And Configuration

Add the middleware inclusion to the `config.ru` file (before the `run Application` directive):

```ruby

  require "rack-refresher"

  use Rack::Refresher do |config|
    config.ajax  = true
    config.delay = 1000
  end

```

**Configuration options**:

* `config.ajax = true` (Default: `false`) Refresh only the `<body>` tag of the page in background via AJAX. The page will be fully reloaded if this option is not set;

* `config.delay = 1000` (Default: `5000`, alias: `config.interval`) Refresh interval defined in milliseconds. 1000 milliseconds == 1 second;

The middleware can be included several times. For example the following code will create 2 refreshers: the first one will refresh the page every 5 seconds via AJAX and the second one will refresh the page every 5 minutes via reload:

```ruby

  require "rack-refresher"

  use Rack::Refresher do |config|
    config.ajax  = true
    config.delay = 5000 # Every 5 seconds
  end

  use Rack::Refresher do |config|
    config.delay = 300_000 # Every 5 minutes
  end

```
