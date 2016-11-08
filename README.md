# Gamewisp

A ruby Gamewisp API library.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gamewisp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gamewisp

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing

`guard` is supported for testing submon.

To successfully run the gamewisp tests, you'll need your gamewisp API key.
Create a file named `.envsetup` in the project root containing the following:

    #!/bin/bash
    # vi: ft=shell

    export GAMEWISP_APP=YOUR APP NAME HERE
    export GAMEWISP_ID=YOUR ID HERE
    export GAMEWISP_SECRET=YOUR SECRET HERE
    export GAMEWISP_ENDPOINT_HOST=localhost
    export GAMEWISP_ENDPOINT_PORT=8080

Replace `YOUR * HERE` with your values and save it.

Before running tests, in the terminal you'll start the tests from,
source `.envsetup` file, then run your tests.
The tests will look for the API key in the environment variables.

    $ source ./.envsetup
    $ bundle exec rspec

Or, if using guard:

    $ source ./.envsetup
    $ bundle exec guard

`.envsetup` is ignored in `.gitignore` so you don't have to worry about your
API key getting uploaded/committed to the repo.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jmcaffee/gamewisp.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

