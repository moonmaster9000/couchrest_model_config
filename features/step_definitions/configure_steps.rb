When /^I call CouchRest::Model::Config\.server$/ do
  @server = CouchRest::Model::Config.server
end

Then /^I should get back a CouchRest server defaulted to host "([^"]*)"$/ do |host|
  @server.uri.should == host 
end

When /^I call CouchRest::Model::Config\.edit$/ do
end

Then /^I should be able to pass a block to it that configures the CouchRest server$/ do
  CouchRest::Model::Config.edit do
    server CouchRest.new("http://localhost:5984")
  end

  CouchRest::Model::Config.server.uri.should == "http://localhost:5984"
end

