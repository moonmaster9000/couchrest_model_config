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
