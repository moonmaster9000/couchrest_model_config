Feature: Support Namespaced models
  As an API designer
  I want to support namespaced models
  So that I don't look like a fool!

  Scenario: Configuring namespace models
    Given I have a namespaced model
    Then  I should be able to configure it just like all other models
    And   I should be able to retrieve configuration information about it via the `for` method on CouchRest::Model::Config
