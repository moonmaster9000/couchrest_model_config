Feature: Resetting the configuration
  
  Scenario: Resetting configuration
    Given I have configured the databases
    When I call the reset method
    Then the couchrest_model database configuration should be reset to defaults
