@db
Feature: Configure CouchRest::Model database connections
  
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

  Scenario Outline: Configuring the database for a set of models
    Given I have several models
    And I set their database via the `database` method
    And my app is in the "<environment>" environment
    When I lookup their current_database 
    Then their database should be the one I configured for the "<target>" environment
    
    Examples:
      |environment|target|
      |test|test|
      |development|development|
      |production|production|
      |poo|default|

  Scenario Outline: Configuring the database for a set of models
    Given I have several models that inherit from a single parent
    And I configure the parent database via the `database` method
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
  
  Scenario Outline: Setting the default database
    Given I have several models
    And I configure default databases for all models for the 'test', 'development', 'production', and 'default' environments
    And I do not configure the database for any specific models
    And my app is in the "<environment>" environment
    When I lookup their current_database 
    Then their database should be the one I configured for the "<target>" environment in the default database configuration section

    Examples:
      |environment|target|
      |test|test|
      |development|development|
      |production|production|
      |poo|default|

  Scenario: Setting the server while configuring the database
    When I configure the database for a model
    Then I should be able to provide the full URI to the database
    And the database should use the domain provided for the server instead of the default server

  @focus
  Scenario: Database configured directly on the model takes highest precedence
    Given I have configured the database for a model directly on the model via `use_database`
    And I have configured the database for that model via CouchRest::Model::Config
    When I call the `database` method on the model
    Then I should receive the database configured directly on the model via `use_database`
  
  @focus
  Scenario: Looking up the model's database via the model itself
    Given I have configured the database for a model via CouchRest::Model::Config
    When I call the `database` method on the model
    Then I should receive the database I configured via CouchRest::Model::Config
    When I call the `database` method on an instance of the model
    Then I should receive the database I configured via CouchRest::Model::Config
