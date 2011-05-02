@server
Feature: Configure CouchRest::Model database connections
  
  Scenario: Default CouchRest server
    When I call CouchRest::Model::Config.server.default
    Then I should get back a CouchRest server defaulted to host "http://127.0.0.1:5984"
  
  Scenario: Configuring the CouchRest server
    When I call CouchRest::Model::Config.edit
    Then I should be able to pass a block to it that configures the default CouchRest server

  Scenario Outline: Getting the appropriate server
    Given I have configured servers for 'default', 'production', 'development', and 'test' environments
    And my app is in the "<environment>" environment
    When I call CouchRest::Model::Config.current_server
    Then I should get back the server I configured for the "<target>" environment
    
    Examples:
      |environment|target|
      |test|test|
      |development|development|
      |production|production|
      |poo|default|
