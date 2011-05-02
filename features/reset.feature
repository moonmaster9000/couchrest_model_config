Feature: Resetting the configuration
  
  Scenario: Resetting configuration
    Given I have configured CouchRest::Model via CouchRest::Model::Config
    When I call the reset method
    Then CouchRest::Model::Config should be reset to defaults 
