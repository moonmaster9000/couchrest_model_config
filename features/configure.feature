Feature: Configure CouchRest::Model database connections
  
  @server
  Scenario: Default CouchRest server
    When I call CouchRest::Model::Config.server.default
    Then I should get back a CouchRest server defaulted to host "http://127.0.0.1:5984"
  
  @server
  Scenario: Configuring the CouchRest server
    When I call CouchRest::Model::Config.edit
    Then I should be able to pass a block to it that configures the default CouchRest server

  @server
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

  @db
  Scenario Outline: Configuring the database for a model 
    Given I have a Book model
    And I have configured databases for 'default', 'production', 'development', and 'test' environments
    And my app is in the "<environment>" environment
    When I call CouchRest::Model::Config.Book.current_database
    Then I should get back the database I cofigured for the "<target>" environment
    
    Examples:
      |environment|target|
      |test|test|
      |development|development|
      |production|production|
      |poo|default|

  @db
  Scenario Outline: Configuring the database for a set of models
    Given I have several models
    And I set their database via the `models` method
    And my app is in the "<environment>" environment
    When I lookup their current_database 
    Then their database should be the one I configured for the "<target>" environment
    
    Examples:
      |environment|target|
      |test|test|
      |development|development|
      |production|production|
      |poo|default|

  @db @focus
  Scenario Outline: Configuring the database for a set of models
    Given I have several models that inherit from a single parent
    And I configure the parent database via the `models` method
    And I do not configure the database for the child models 
    And my app is in the "<environment>" environment
    When I lookup the current_database for the child models 
    Then their database should be the one I configured for the "<target>" environment on the parent
    
    Examples:
      |environment|target|
      |test|test|
      |development|development|
      |production|production|
      |poo|default|
