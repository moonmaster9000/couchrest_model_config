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
