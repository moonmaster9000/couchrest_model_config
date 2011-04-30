# CouchRest::Model::Config

Simple environment-based CouchRest::Model configuration. Suitable for Rails, Sinatra, Rack, whatev. 

## Installation

Install the gem `couchrest_model_config` however you see fit to do so. Then `require 'couchrest_model_config'`.

## Configuring environment detection

By default, CouchRest::Model::Config assumes a Rails 3 app, and will detect your app's environment via `Rails.env`. If you're using this in something other than a Rails 3 app,
then simply override the default environment detection:
    
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

## Configuring the database for a model

To set the database for a model, use the `model` method. For example, suppose we'd like to set the database name for our `Book` model to 
`library` in all environments:

    CouchRest::Model::Config.edit do
      model Book do
        default "library"
      end
    end

Or, perhaps we'd like to differentiate the name between production, development, and test environments:

    CouchRest::Model::Config.edit do
      model Book do
        production "library_production"
        development "library_development"
        test "library_test"
      end
    end

In a Rails app, this could be simplified to:

    CouchRest::Model::Config.edit do
      model Book do
        default "library_#{Rails.env}"
      end
    end

## Configuring the database for a set of models

Similarly, you could set the database for a whole set of models in one of two ways:

1. Make every model inherit from the same parent, and set the parent's database via the `model` method
2. Use the `models` method

### Inheritance

Let's imagine that our `Book`, `Author`, and `Genre` models all inherited from the `Library` class, which itself inherited from `CouchRest::Model::Base`:

    class Library < CouchRest::Model::Base; end
    class Book < Library; end
    class Author < Library; end
    class Genre < Library; end

To make the `Book`, `Author`, and `Genre` models use the same database, simply set the `Library` database in the config:

    CouchRest::Model::Config.edit do
      model Library do
        default "library"
      end
    end

Now, the database for `Book`, `Author`, and `Genre` will all be set to the same database.

### The `models` method

Suppose `Book`, `Author`, and `Genre` couldn't all inherit from the same parent class, yet we'd still like all of them to share the same database;
then we could use the `models` method:

    CouchRest::Model::Config.edit do
      models Book, Author, Genre do
        default "library"
      end
    end

## Configuring the CouchDB server 

Without any configuration, CouchRest::Model::Config will assume a CouchDB server at "http://127.0.0.1:5984". 

If you'd like to set a default server for all models regardless of environment, then try:

    CouchRest::Model::Config.edit do
      server do
        default "http://admin:password@localhost:5984"
      end
    end

If you wanted to change the server to be different in the `production` environment:

    CouchRest::Model::Config.edit do
      server do
        default "http://admin:password@localhost:5984"
        production "https://root:blah@my.production.server:5984"
      end
    end

Now, in the production environment, it will connect to CouchDB server `my.production.server`; in all other environments, it will connect to `localhost`.

If you'd like to change the CouchDB server for a specific model or set of models, simply set the database name for the model (or models) to the entire
CouchDB uri for the database:

    CouchRest::Model::Config.edit do
      model Blog do
        default "http://localhost:5984/blog"
      end
    end
