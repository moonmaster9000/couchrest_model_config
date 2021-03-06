# CouchRest::Model::Config

Simple environment-based CouchRest::Model configuration. Suitable for Rails, Sinatra, Rack, whatev. 

## Installation

Install the gem `couchrest_model_config` however you see fit to do so. Then `require 'couchrest_model_config'`.

## Configuring environment detection

By default, CouchRest::Model::Config assumes a Rails 3 app, and will detect your app's environment via `Rails.env`. If you're using this in something other than a Rails 3 app,
then simply override the default environment detection:

```ruby
# Sinatra example
CouchRest::Model::Config.edit do
  environment do
    settings.environment
  end
end

# Rack example
CouchRest::Model::Config.edit do
  environment do
    ENV['RACK_ENV'] || 'development'
  end
end
```

## Configuring the default database

Suppose you want all of your couchrest models to use the same database in your application. No problem! You can use the `database` configuration method without
any arguments:

```ruby
CouchRest::Model::Config.edit do
  database do
    default "my_db_#{Rails.env}"
  end
end
```

This means that the default database name for all of your models will be "my_db_" followed by your Rails environment.

You could customize the database names per environment further:

```ruby
CouchRest::Model::Config.edit do
  database do
    default "my_db_#{Rails.env}"
    production "my_production_db"
    test "funny_test_db_name"
  end
end
```

For any environment not explicitly configured, it will fall back to the database name.

## Configuring the database for a model

To set the database for a model, use the `database` method. For example, suppose we'd like to set the database name for our `Book` model to 
`library` in all environments:

```ruby
CouchRest::Model::Config.edit do
  database Book do
    default "library"
  end
end
```

Or, perhaps we'd like to differentiate the name between production, development, and test environments:

```ruby
CouchRest::Model::Config.edit do
  database Book do
    production "library_production"
    development "library_development"
    test "library_test"
  end
end
```

In a Rails app, this could be simplified to:

```ruby
CouchRest::Model::Config.edit do
  database Book do
    default "library_#{Rails.env}"
  end
end
```

## Configuring the database for a set of models

Similarly, you could set the database for a whole set of models in one of two ways:

1. Make every model inherit from the same parent (or mixin the same module), and set the parent's database via the `database` method
2. Pass several models to the `database` method

### Inheritance / Mixins

Let's imagine that our `Book`, `Author`, and `Genre` models all mixed in the `Library` module:

```ruby
module Library; end
class Book    < CouchRest::Model::Base; include Library; end
class Author  < CouchRest::Model::Base; include Library; end
class Genre   < CouchRest::Model::Base; include Library; end
```

To make the `Book`, `Author`, and `Genre` models use the same database, simply set the `Library` database in the config:

```ruby
CouchRest::Model::Config.edit do
  database Library do
    default "library"
  end
end
```

Now, the database for `Book`, `Author`, and `Genre` will all be set to the same database, "library".

### Passing several models to the `database` method

Suppose `Book`, `Author`, and `Genre` couldn't all inherit from the same parent class, yet we'd still like all of them to share the same database;
then we could simply pass all of the models to the `database` method:

```ruby
CouchRest::Model::Config.edit do
  database Book, Author, Genre do
    default "library"
  end
end
```

## Configuring the CouchDB server 

Without any configuration, CouchRest::Model::Config will assume a CouchDB server at "http://127.0.0.1:5984". 

If you'd like to set a default server for all models regardless of environment, then try:

```ruby
CouchRest::Model::Config.edit do
  server do
    default "http://admin:password@localhost:5984"
  end
end
```

If you wanted to change the server to be different in the `production` environment:

```ruby
CouchRest::Model::Config.edit do
  server do
    default "http://admin:password@localhost:5984"
    production "https://root:blah@my.production.server:5984"
  end
end
```

Now, in the production environment, it will connect to CouchDB server `my.production.server`; in all other environments, it will connect to `localhost`.

If you'd like to change the CouchDB server for a specific model or set of models, simply set the database name for the model (or models) to the entire
CouchDB uri for the database:

```ruby
CouchRest::Model::Config.edit do
  database Blog do
    default "http://localhost:5984/blog"
  end
end
```

## LICENSE

There is no license. Why? Because this software has been committed to the public domain. DO ANYTHING WITH IT!!!
