@environment
Feature: Configuring and Retrieving the environment
  
  Scenario: Environment should default to Rails.env
    Given Rails.env returns "hi"
    When I call CouchRest::Model::Config.environment
    Then I should receive the value of "Rails.env"

  Scenario: Changing the environment detection
    Given I have configured couchrest_model to detect environment via ENV['RACK_ENV']
    When I call CouchRest::Model::Config.environment
    Then I should receive the value of "ENV['RACK_ENV']"
