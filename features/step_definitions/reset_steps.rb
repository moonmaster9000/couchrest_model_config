Given /^I have configured CouchRest::Model via CouchRest::Model::Config$/ do
  class Book < CouchRest::Model::Base; end
  CouchRest::Model::Config.edit do
    database Book do
      default "book_db" 
    end

    environment do
      "haha"
    end

    server do
      default "http://poo.com"
    end
  end
  CouchRest::Model::Config.Book.default.class.should == CouchRest::Database
  CouchRest::Model::Config.Book.default.name.should == "book_db"
  CouchRest::Model::Config.server.default.uri.should == "http://poo.com"
  CouchRest::Model::Config.environment.should == "haha"
end

When /^I call the reset method$/ do
  CouchRest::Model::Config.reset
end

Then /^CouchRest::Model::Config should be reset to defaults$/ do
  unless defined? Rails
    Rails = double "Rails"
  end
  Rails.stub(:env).and_return "matt"
  CouchRest::Model::Config.Book.all.should be_nil
  CouchRest::Model::Config.Book.default.should be_nil
  CouchRest::Model::Config.server.default.uri.should == "http://127.0.0.1:5984"
  CouchRest::Model::Config.environment.should == "matt"
end
