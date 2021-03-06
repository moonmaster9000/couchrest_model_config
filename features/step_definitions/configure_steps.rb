When /^I call CouchRest::Model::Config\.server\.default$/ do
  @default_server = CouchRest::Model::Config.server.default
end

Then /^I should be able to pass a block to it that configures the default CouchRest server$/ do
  CouchRest::Model::Config.edit do
    server do
      default "http://localhost:5984"
    end
  end
end

Given /^I have configured servers for 'default', 'production', 'development', and 'test' environments$/ do
  CouchRest::Model::Config.edit do
    server do
      default     "http://default:5984"
      production  "http://production:5984"
      development "http://development:5984"
      test        "http://test:5984"
    end
  end
end

Given /^my app is in the "([^"]*)" environment$/ do |env|
  CouchRest::Model::Config.edit do
    environment do
      env
    end
  end
end

When /^I call CouchRest::Model::Config\.current_server$/ do
  @current_server = CouchRest::Model::Config.current_server
end

Then /^I should get back the server I configured for the "([^"]*)" environment$/ do |env|
  @current_server.uri.should == "http://#{env}:5984"
end

Then /^I should get back a CouchRest server defaulted to host "([^"]*)"$/ do |host_uri|
  @default_server.uri.should == host_uri 
end

When /^I call CouchRest::Model::Config\.edit$/ do
end

Given /^I have a Book model$/ do
  class Book < CouchRest::Model::Base; end
end

Given /^I have configured databases for 'default', 'production', 'development', and 'test' environments$/ do
  CouchRest::Model::Config.edit do
    database Book do
      default "book_default_db"
      production "book_production_db"
      development "book_development_db"
      test "book_test_db"
    end
  end
end

When /^I call CouchRest::Model::Config\.Book\.current_database$/ do
  @current_database = CouchRest::Model::Config.Book.current_database
end

Then /^I should get back the database I cofigured for the "([^"]*)" environment$/ do |env|
  @current_database.name.should == "book_#{env}_db"
end

Given /^I have several models$/ do
  class Models1 < CouchRest::Model::Base; end 
  class Models2 < CouchRest::Model::Base; end 
  class Models3 < CouchRest::Model::Base; end 
  class Models4 < CouchRest::Model::Base; end 
end

Given /^I set their database via the `database` method$/ do
  CouchRest::Model::Config.edit do
    database Models1, Models2, Models3, Models4 do
      default "default_db"
      test "test_db"
      development "development_db"
      production "production_db"
    end
  end
end

When /^I lookup their current_database$/ do
  @dbs = (1..4).to_a.map {|i| CouchRest::Model::Config.send("Models#{i}").current_database}
end

Then /^their database should be the one I configured for the "([^"]*)" environment$/ do |env|
  @dbs.all? {|db| db.name == "#{env}_db"}.should be_true
end

Given /^I have several models that inherit from a single parent$/ do
  class ParentModel < CouchRest::Model::Base; end
  class ChildModel1 < ParentModel; end
  class ChildModel2 < ParentModel; end
  class ChildModel3 < ParentModel; end
  class ChildModel4 < ParentModel; end
end

Given /^I configure the parent database via the `database` method$/ do
  CouchRest::Model::Config.edit do 
    database ParentModel do
      default "default_db"
      production "production_db"
      development "development_db"
      test "test_db"
    end
  end
end

Given /^I do not configure the database for the child models$/ do
end

When /^I lookup the current_database for the child models$/ do
  @dbs = (1..4).to_a.map {|i| CouchRest::Model::Config.send("ChildModel#{i}").current_database}
end

Then /^their database should be the one I configured for the "([^"]*)" environment on the parent$/ do |env|
  @dbs.all? {|db| db.name == "#{env}_db"}.should be_true
end

Given /^I configure default databases for all models for the 'test', 'development', 'production', and 'default' environments$/ do
  CouchRest::Model::Config.edit do
    database do
      default "default_db"
      production "production_db"
      development "development_db"
      test "test_db"
    end
  end
end

Given /^I do not configure the database for any specific models$/ do
end

Then /^their database should be the one I configured for the "([^"]*)" environment in the default database configuration section$/ do |env|
  @dbs.all? {|db| db.name == "#{env}_db"}.should be_true
end

Given /^I have a namespaced model$/ do
  module ConfigTest
    class Model < CouchRest::Model::Base; end
  end
end

Then /^I should be able to configure it just like all other models$/ do
  CouchRest::Model::Config.edit do
    database ConfigTest::Model do
      production "config_test_model_production"
      default "config_test_model_default"
    end
  end
end

Then /^I should be able to retrieve configuration information about it via the `for` method on CouchRest::Model::Config$/ do
  CouchRest::Model::Config.for(ConfigTest::Model).production.name.should == "config_test_model_production"
  CouchRest::Model::Config.for(ConfigTest::Model).default.name.should == "config_test_model_default"
  CouchRest::Model::Config.for(ConfigTest::Model).test.should be_nil
end

When /^I configure the database for a model$/ do
  class ModelWithCustomServer < CouchRest::Model::Base; end
end

Then /^I should be able to provide the full URI to the database$/ do
  CouchRest::Model::Config.edit do
    database ModelWithCustomServer do
      default "http://my.custom.server.com/model_db"
    end
  end
end

Then /^the database should use the domain provided for the server instead of the default server$/ do
  CouchRest::Model::Config.ModelWithCustomServer.default.name.should == "model_db"
  CouchRest::Model::Config.ModelWithCustomServer.default.server.uri.should == "http://my.custom.server.com"
end

Given /^I have configured the database for a model directly on the model via `use_database`$/ do
  server = CouchRest.new
  DIRECTLY_CONFIGURED_MODEL_DB = server.database! "directly_configured_model_database"
  class DirectlyConfiguredModel < CouchRest::Model::Base
    use_database DIRECTLY_CONFIGURED_MODEL_DB
  end
  @model = DirectlyConfiguredModel
end

Given /^I have configured the database for that model via CouchRest::Model::Config$/ do
  CouchRest::Model::Config.edit do
    database DirectlyConfiguredModel do
      default "indirectly_configured_db"
    end
  end
end

When /^I call the `database` method on the model$/ do
  @model_database = @model.database 
end

Then /^I should receive the database configured directly on the model via `use_database`$/ do
  @model_database.name.should == "directly_configured_model_database"
end

Given /^I have configured the database for a model via CouchRest::Model::Config$/ do
  class IndirectlyConfiguredModel < CouchRest::Model::Base; end
  CouchRest::Model::Config.edit do
    database IndirectlyConfiguredModel do
      default "indirect_db"
    end
  end
  @model = IndirectlyConfiguredModel
end

Then /^I should receive the database I configured via CouchRest::Model::Config$/ do
  @model_database.name.should == "indirect_db"
end

When /^I call the `database` method on an instance of the model$/ do
  @model_database = IndirectlyConfiguredModel.new.database
end

When /^I call the `use_database` method on CouchRest::Model::Base$/ do
  @call = proc { CouchRest::Model::Base.use_database }
end

Then /^I should receive an exception that the `use_database` method is not suported with couchrest_model_config$/ do
  @call.should raise_exception("We're sorry, but the `use_database` method is not supported with couchrest_model_config.")
end
