Given /^I have configured the databases$/ do
  class Book < CouchRest::Model::Base; end
  CouchRest::Model::Config.Book.all.should be_nil
  CouchRest::Model::Config.edit do
    model Book do
      all "book_db" 
    end
  end
  CouchRest::Model::Config.Book.all.class.should == CouchRest::Database
  CouchRest::Model::Config.Book.all.name.should == "book_db"
end

When /^I call the reset method$/ do
  CouchRest::Model::Config.reset
end

Then /^the couchrest_model database configuration should be reset to defaults$/ do
  CouchRest::Model::Config.Book.all.should be_nil
end
