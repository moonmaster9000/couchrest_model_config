Feature: Configure CouchRest::Model database connections
  
  Scenario: Default CouchRest server
    When I call CouchRest::Model::Config.server
    Then I should get back a CouchRest server defaulted to host "http://127.0.0.1:5984"

  Scenario: Configuring the CouchRest server
    When I call CouchRest::Model::Config.edit
    Then I should be able to pass a block to it that configures the CouchRest server
