Given /^Rails\.env returns "([^"]*)"$/ do |rails_env|
  unless defined? Rails
    Rails = double "Rails"
  end
  Rails.stub(:env).and_return rails_env
  Rails.env.should == rails_env
end

When /^I call CouchRest::Model::Config\.environment$/ do
  @env = CouchRest::Model::Config.environment
end

Then /^I should receive the value of "([^"]*)"$/ do |eval_this|
  @env.should == eval(eval_this) 
end

Given /^I have configured couchrest_model to detect environment via ENV\['RACK_ENV'\]$/ do
  ENV['RACK_ENV'] = 'matt did this!'
  CouchRest::Model::Config.edit do
    environment do
      ENV['RACK_ENV']
    end
  end
end
