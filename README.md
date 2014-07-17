# DrbStore

A simple implementation of the ActiveSupport::Cache::Store interface using DRb.

### usage

Add the store to your Rails config:

```
# rails config

config.cache_store = [:drb_cached]
```

start a DRbCached::Server

```
# from the repo directory
$ bundle exec bin/drb_store
```

## Installation

Add this line to your application's Gemfile:

    gem 'drb_store'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install drb_store

## Contributing

1. Fork it ( https://github.com/[my-github-username]/drb_store/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
