# telesink-rails-requests

Rails request tracking for [Telesink](https://telesink.com).

Automatically tracks every HTTP request in your Rails app — method, path,
status, duration, controller, action, and more.

## Installation

Add to your `Gemfile`:

```ruby
gem "telesink-rails-requests"
```

Then run:

```sh
bundle install
```

## Configuration

No extra setup needed. It uses the same `TELESINK_ENDPOINT` as the core gem.

To send request events to a **separate sink** (recommended for folders):

```sh
export TELESINK_REQUESTS_ENDPOINT="https://app.telesink.com/api/v1/sinks/your_requests_sink_token/events"
```

## How it works

Every request processed by Rails automatically gets tracked with:

- HTTP method and full path
- Response status
- Controller and action name
- Total duration, DB time, and view time
- IP address, user agent, and request ID

Events are sent using the same conventions as the [core SDK](https://github.com/telesink/telesink-ruby).

## License

MIT (see [LICENSE.md](/LICENSE.md)).
