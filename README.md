# GraphQL::Model

A Ruby library to make using GraphQL 100% more awesome

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-model'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphql-model

## Usage

Write it as Ruby.

```ruby
query = GraphQL::Model.query do
  graphQLClient(language: :ruby, best: true) do
    title
    description
  end
end.to_query_string
```

It works just like GraphQL.

```graphql
{
  graphQLClient(language: ruby, best: true) {
    title
    description
  }
}
```

And it gets what you ask for. 

```json
{
  "graphQLClient": {
    "title": "GraphQL::Model",
    "description": "A better way to write GraphQL queries in Ruby."
  }
}
```

[And more](https://github.com/benaubin/graphql-model/wiki/Fields).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/graphql-model. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Graphql::Model project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/graphql-model/blob/master/CODE_OF_CONDUCT.md).
